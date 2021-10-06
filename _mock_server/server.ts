import express from "express";
import cors from "cors";

interface DbInterface {
    [key: number]: Employee;
}

interface Employee {
    name: string,
    flex: number,
    working: boolean,
    department: string;
    photo: string;
}

const db: DbInterface = {
    0: {
        name: 'testuser0',
        flex: 10000,
        working: false,
        department: 'department0',
        photo: "https://via.placeholder.com/240x320?text=employee0"
    },
    1: {
        name: 'testuser1',
        flex: 20000,
        working: true,
        department: 'department0',
        photo: "https://via.placeholder.com/320x240?text=employee1"
    },
    2: {
        name: 'testuser2',
        flex: 30000,
        working: true,
        department: 'department2',
        photo: "https://via.placeholder.com/400x400?text=employee2"
    },
    3: {
        name: 'testuser3',
        flex: 40000,
        working: true,
        department: 'department2',
        photo: "https://via.placeholder.com/240x320?text=employee3"
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
        
        return res.status(400).json({error: "employee does not exist"});
    });

    app.post('/api/employee/cardscanned', (req, res) => {
        const employeeId = req.body.employeeId

        if (!employeeId) 
            return res.status(400).json({ error: 'no userid given' });
        if (!db[employeeId]) 
            return res.status(400).json({ error: 'user doesnt exist' });
        if (req.body.checkingIn === null || req.body.checkingIn === undefined) 
            return res.status(400).json({ error: 'checkingIn not given' })

        db[employeeId].working = req.body.checkingIn;
        
        return res.status(200).json({ employee: db[employeeId] });
    });

    app.get('/api/employees/working', (req, res) => {

        const employeesUnordered: Employee[] = [];
        const employeesOrdered: {[department: string]: Employee[]} = {};

        const filtered = Object.entries(db).filter((user) => user[1].working);
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