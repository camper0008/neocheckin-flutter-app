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
        photo: "iVBORw0KGgoAAAANSUhEUgAAAPAAAAFABAMAAABwxuxgAAAAG1BMVEXMzMyWlpbFxcWqqqqcnJy3t7e+vr6xsbGjo6OSPOvNAAAACXBIWXMAAA7EAAAOxAGVKw4bAAACKElEQVR4nO3WT47aMBTH8UdIKMs4CX+WgelIXYaKAyRzgiD1ALSLqkuoeoBxVXHuPscemM6qSJ6hUr8fiScDT/kFx3EQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA+F+k+b8XnGzL+ibBK2MebhJsT9+WtwhOqjrp6ighybbqNelTdRh3Jx38WPZD8F33U8YLca+hxdd3+smxjxL82ZiFpIvKLuwvU6dlZWcueGKM2Wc6q+nct/g6neugiRLcne41z/SZmcum0cFE3+aSll82rZhaVrlv8XVa6Pp6jJHrftTukJYi5qCHdIPjQYN3jzKdie1l1/iW0KgXYdTGCHZzN2p1PqWrw0Djc9n0kpVybHTgW3wdueAo20tarNfv81RnsBvOoBhq7k4jWcqq1cFTi6vxgke6iEzhZrALkXpgrUa/M3pamu5bLo1xpnrljjf/M7g9B49n2SK0+Bpvcfl5uwQX4RrbYaonpSb5Fl+H2ylKsEvK+kvwTNduc15cUum8hpahZtE2kLEefdVegvWmsfvz7SR214QWX+NtmYn5ft89+8Xm410lwway1g1Edt0+tPga8SFxNKZ8do2XuoLOW6Zbe08toeoaK+IET2x4KoRVvV3uh7cfzEm/dVPvW0JNNq/zR+DlA3E8e42UvwhOI83r1cFx7tnrg7/aOA/9q4Nt9Ua5L4M3p7cKBgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwM38BtQgUAi6FiWHAAAAAElFTkSuQmCC"
    },
    1: {
        name: 'testuser1',
        flex: 20000,
        working: true,
        department: 'department0',
        photo: "iVBORw0KGgoAAAANSUhEUgAAAPAAAAFABAMAAABwxuxgAAAAG1BMVEXMzMyWlpbFxcWqqqqcnJy3t7e+vr6xsbGjo6OSPOvNAAAACXBIWXMAAA7EAAAOxAGVKw4bAAACKElEQVR4nO3WT47aMBTH8UdIKMs4CX+WgelIXYaKAyRzgiD1ALSLqkuoeoBxVXHuPscemM6qSJ6hUr8fiScDT/kFx3EQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA+F+k+b8XnGzL+ibBK2MebhJsT9+WtwhOqjrp6ighybbqNelTdRh3Jx38WPZD8F33U8YLca+hxdd3+smxjxL82ZiFpIvKLuwvU6dlZWcueGKM2Wc6q+nct/g6neugiRLcne41z/SZmcum0cFE3+aSll82rZhaVrlv8XVa6Pp6jJHrftTukJYi5qCHdIPjQYN3jzKdie1l1/iW0KgXYdTGCHZzN2p1PqWrw0Djc9n0kpVybHTgW3wdueAo20tarNfv81RnsBvOoBhq7k4jWcqq1cFTi6vxgke6iEzhZrALkXpgrUa/M3pamu5bLo1xpnrljjf/M7g9B49n2SK0+Bpvcfl5uwQX4RrbYaonpSb5Fl+H2ylKsEvK+kvwTNduc15cUum8hpahZtE2kLEefdVegvWmsfvz7SR214QWX+NtmYn5ft89+8Xm410lwway1g1Edt0+tPga8SFxNKZ8do2XuoLOW6Zbe08toeoaK+IET2x4KoRVvV3uh7cfzEm/dVPvW0JNNq/zR+DlA3E8e42UvwhOI83r1cFx7tnrg7/aOA/9q4Nt9Ua5L4M3p7cKBgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwM38BtQgUAi6FiWHAAAAAElFTkSuQmCC"
    },
    2: {
        name: 'testuser2',
        flex: 30000,
        working: true,
        department: 'department2',
        photo: "iVBORw0KGgoAAAANSUhEUgAAAPAAAAFABAMAAABwxuxgAAAAG1BMVEXMzMyWlpbFxcWqqqqcnJy3t7e+vr6xsbGjo6OSPOvNAAAACXBIWXMAAA7EAAAOxAGVKw4bAAACKElEQVR4nO3WT47aMBTH8UdIKMs4CX+WgelIXYaKAyRzgiD1ALSLqkuoeoBxVXHuPscemM6qSJ6hUr8fiScDT/kFx3EQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA+F+k+b8XnGzL+ibBK2MebhJsT9+WtwhOqjrp6ighybbqNelTdRh3Jx38WPZD8F33U8YLca+hxdd3+smxjxL82ZiFpIvKLuwvU6dlZWcueGKM2Wc6q+nct/g6neugiRLcne41z/SZmcum0cFE3+aSll82rZhaVrlv8XVa6Pp6jJHrftTukJYi5qCHdIPjQYN3jzKdie1l1/iW0KgXYdTGCHZzN2p1PqWrw0Djc9n0kpVybHTgW3wdueAo20tarNfv81RnsBvOoBhq7k4jWcqq1cFTi6vxgke6iEzhZrALkXpgrUa/M3pamu5bLo1xpnrljjf/M7g9B49n2SK0+Bpvcfl5uwQX4RrbYaonpSb5Fl+H2ylKsEvK+kvwTNduc15cUum8hpahZtE2kLEefdVegvWmsfvz7SR214QWX+NtmYn5ft89+8Xm410lwway1g1Edt0+tPga8SFxNKZ8do2XuoLOW6Zbe08toeoaK+IET2x4KoRVvV3uh7cfzEm/dVPvW0JNNq/zR+DlA3E8e42UvwhOI83r1cFx7tnrg7/aOA/9q4Nt9Ua5L4M3p7cKBgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwM38BtQgUAi6FiWHAAAAAElFTkSuQmCC"
    },
    3: {
        name: 'testuser3',
        flex: 40000,
        working: true,
        department: 'department2',
        photo: "iVBORw0KGgoAAAANSUhEUgAAAPAAAAFABAMAAABwxuxgAAAAG1BMVEXMzMyWlpbFxcWqqqqcnJy3t7e+vr6xsbGjo6OSPOvNAAAACXBIWXMAAA7EAAAOxAGVKw4bAAACKElEQVR4nO3WT47aMBTH8UdIKMs4CX+WgelIXYaKAyRzgiD1ALSLqkuoeoBxVXHuPscemM6qSJ6hUr8fiScDT/kFx3EQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA+F+k+b8XnGzL+ibBK2MebhJsT9+WtwhOqjrp6ighybbqNelTdRh3Jx38WPZD8F33U8YLca+hxdd3+smxjxL82ZiFpIvKLuwvU6dlZWcueGKM2Wc6q+nct/g6neugiRLcne41z/SZmcum0cFE3+aSll82rZhaVrlv8XVa6Pp6jJHrftTukJYi5qCHdIPjQYN3jzKdie1l1/iW0KgXYdTGCHZzN2p1PqWrw0Djc9n0kpVybHTgW3wdueAo20tarNfv81RnsBvOoBhq7k4jWcqq1cFTi6vxgke6iEzhZrALkXpgrUa/M3pamu5bLo1xpnrljjf/M7g9B49n2SK0+Bpvcfl5uwQX4RrbYaonpSb5Fl+H2ylKsEvK+kvwTNduc15cUum8hpahZtE2kLEefdVegvWmsfvz7SR214QWX+NtmYn5ft89+8Xm410lwway1g1Edt0+tPga8SFxNKZ8do2XuoLOW6Zbe08toeoaK+IET2x4KoRVvV3uh7cfzEm/dVPvW0JNNq/zR+DlA3E8e42UvwhOI83r1cFx7tnrg7/aOA/9q4Nt9Ua5L4M3p7cKBgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwM38BtQgUAi6FiWHAAAAAElFTkSuQmCC"
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
        const employeeId = parseInt(req.params.id) ?? -1;
        if (db[employeeId]) return res.status(200).json({employee: db[employeeId]});
        
        return res.status(400).json({error: "employee does not exist"});
    });

    app.post('/api/employee/cardscanned', (req, res) => {
        const employeeId = parseInt(req.body.employeeId ?? '-1') ?? -1

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