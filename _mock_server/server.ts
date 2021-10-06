import express from "express";
import cors from "cors";

interface DbInterface {
    [key: string]: Employee;
}

interface Employee {
    name: string,
    flex: number,
    checkedIn: boolean,
    department: string;
}

const db: DbInterface = {
    "user": {
        name: 'testuser',
        flex: 50000,
        checkedIn: false,
        department: 'department1',
    },
    "user2": {
        name: 'testuser2',
        flex: 420,
        checkedIn: true,
        department: 'department1',
    },
    "user3": {
        name: 'testuser3',
        flex: 420,
        checkedIn: true,
        department: 'department2',
    },
    "user4": {
        name: 'testuser4',
        flex: 420,
        checkedIn: true,
        department: 'department2',
    },
};
const server = () => {
    const app = express();
    app.use(express.json());
    app.use(cors());
    app.get('/', (req, res) => {
        return res.sendFile('/home/pieter/Desktop/gitlab/neocheckin/flutter-app/build/web/index.html');
    })
    app.use('/', express.static('/home/pieter/Desktop/gitlab/neocheckin/flutter-app/build/web'));

    app.get('/api/employee/:id', (req, res) => {
        const employeeId = req.params.id;
        if (db[employeeId]) return res.status(200).json({employee: db[employeeId]});
        
        return res.status(400).json({error_msg: "employee does not exist"});
    });

    app.post('/api/employee/cardscanned', (req, res) => {
        const employeeId = req.body.employeeId

        if (!employeeId) 
            return res.status(400).json({ error_msg: 'no userid given' });
        if (!db[employeeId]) 
            return res.status(400).json({ error_msg: 'user doesnt exist' });
        if (req.body.checkingIn === null || req.body.checkingIn === undefined) 
            return res.status(400).json({ error_msg: 'checkingIn not given' })

        db[employeeId].checkedIn = req.body.checkingIn;
        
        return res.status(200).json({ employee: db[employeeId] });
    });

    app.get('/api/employees/working', (req, res) => {

        const employeesUnordered: Employee[] = [];
        const employeesOrdered: {[department: string]: Employee[]} = {};

        const filtered = Object.entries(db).filter((user) => user[1].checkedIn);
        const mapped = filtered.map((entryKeyPair) => entryKeyPair[1]);

        for (let index in mapped) {
            const employee = mapped[index];
            if (!employeesOrdered[employee.department]) {
                employeesOrdered[employee.department] = [];
            }
            employeesOrdered[employee.department].push(employee);
            employeesUnordered.push(employee);
        }

        return res.status(200).json({
            employees: employeesUnordered, 
            ordered: employeesOrdered, 
        });
    });

    app.listen(8079, () => {
        console.log('server started')
    })
}

server();