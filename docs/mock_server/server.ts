import express from "express";
import cors from "cors";
import { readFile } from "fs/promises"
import { join } from "path";

interface DbInterface {
    [rfid: string]: Employee;
}

interface Employee {
    name: string,
    flex: number,
    working: boolean,
    department: string;
    photo: string;
}

interface Option {
    id: number;
    name: string;
}

const options: Option[] = [
    {
        id: 0,
        name: 'Gåtur'
    },
    {
        id: 1,
        name: 'Efter aftale'
    },
    {
        id: 2,
        name: 'Biblioteksvagt'
    }
]

const db: DbInterface = {
    '0': {
        name: 'testuser0',
        flex: 10000,
        working: false,
        department: 'department0',
        photo: ''
    },
    '1': {
        name: 'testuser1',
        flex: 20000,
        working: true,
        department: 'department0',
        photo: "iVBORw0KGgoAAAANSUhEUgAAAUAAAADwBAMAAACDA6BYAAAAG1BMVEXMzMyWlpbFxcWxsbGjo6OcnJyqqqq+vr63t7f/2tAOAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAC5UlEQVR4nO3XPY/aQBCA4QUDdpk5bO5Ko3zUsRSlxpGux4qS+rgiSYmLKC0U+d+Z2bXPSwgduIjepzib81g77OfgHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD8l14/5t/9tS6e7Zo95od/hE0/yNeyu2+2l+OuLhX1Sduz63tNpBbJy/O4oz5ehttEtpfjrm4tRSOFc61dH5yb2XVzFqbf44vIoXtlezHu+nbaDUdtucnL6U70vtinzcNZ2Fx7+Z3c+fvaErwQd302nzLZpKFXNNF77c38LKwtLDOfUFZY7IW46/PzTraJXVN5mtqwzbQnnQ2lXo4hicrmX7vy/37QBOO4m5ravNLWZrL3V59oEibbQp5CT6naLmufbL3RBOO429PWQmfIdmGJppaZ5Xuvo/8UErTpN7FxzqTUBOO4m0t3RZl8c11Pli6Mn6pyXRylv/1oqfgefLvU7+FO4m6s9fug0e6ai93YKnC2dPfVKoo82ofd1h6fxN0+wedwt5b9JG5YV3dzNwTakOuw7u3xZNwEbUJp280qTDPXvAqPmtzWQu+nTbn5yud1GndjaRV24Eqn1GnDrRRDWCI2BXWER09Qx852uTeyKvuh6xqeyXBW6OH7bCN8cNEQj5Sg340zf9SeTv5Ehil49MnO8/B4tEUy/WV/bf+o/Fo+3T7W8rKIk1C7TMQrRttmFr4nJrkmsAyf4w14Jy+HWRWWS5/gaBt14jPQU78NKzmLj7CpfO77KJVw5PUJZmMddZlvQ0uB7sw9KQIWcuj+bXv28NK4xYJVx3KX9hteHZVRWmMdu32mXUYv2Tv1WOXWTveW31bFlOFzXIhq/TfvRrGKThQ3asEaSv5yFubWJi7lM00k63aS2j/OhwRHK/mz8KNpHhLcxj+GfO/VYWybsDaGBEf70eTeNcWPl9Vp9X/d/5z0xXQbxl7+TjCKAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAG7hD4habdhDn1dbAAAAAElFTkSuQmCC"
    },
    '2': {
        name: 'testuser2',
        flex: 30000,
        working: true,
        department: 'department2',
        photo: "iVBORw0KGgoAAAANSUhEUgAAAfQAAAH0BAMAAAA5+MK5AAAAG1BMVEXMzMyWlpacnJy3t7fFxcW+vr6xsbGqqqqjo6PhoLtdAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAD6klEQVR4nO3aTW8aRxgAYIwXzDHjJnGOoV/K0T5U6hF6yDlUzT1Uldpj6S8IrdTf3flY8DZNvSwWZg7PczCz4Fea0cy+87E7GgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA8Bnfz9/c7sqXf17/9ZTR5/VDCOH6XSk383jxzdNFP7lxKL5IF5NcfFF+WeWLdyeMPrOLbuWXpbxI5aaUn58w+syW3cpvS/ljKs9K+dUJo8+sW/nLEF4u3rZj9i6EX5p1z5h9XPSZrcKXWcpIs1zVVemrbWrDpO3E00Sf2V25N7NleBn/TvPtGm/WD/Fi/fDt+rjoM1uHbvl1+pinak/DdSqPc3tOFH1mm04m2uauim34mIZvrvX04Uz1uOgz297cl9uJaRmepWkrj9U4ck8XfWbz+yE5KaM0DtMXKV29Lr/vk/S4zdfr3aplUHSFypScXYbSh1fpu7vwe77YhN2qvM3XTTdtHx5dn6bThdM2KeXPdblz95+jdsKKTbvP6kOiqzMJzyd/XP+9SOWrtg9z/+36a9d/o92UvQw3R0VX5zI828TVWG7NrO3DSWritr1LV/fDO/b3bWrV86OiqzMNb/JK9OtRSlClUU1KWPN2WC/bhJW/j+V2sTI8ujpX7SL8enFA5ddxTM/aRD48ujbtDiuke3KcZuTRvvLlH7qVH8cfVp2kPiy6NnGyvvmp+Tnvty7ayo/SQmS3GNl/Ocp7s9tt9+4dFF2bi3yi1GxTbuqv/Dx89a996LDoyixLXp6lybq/8qtdOj8qujJvf80TcJPmrf67dfbJmdOw6EptY6bqz9Hp4PHD0dGVuot1PKDymzyPHRtdp1THA9Zj6+6sPji6TmmX3b8Kb/5nwB8WXamUivv3XlftovW46EqlIdu/406T2+dO2w6Lrkvz/n0ppGOV/nOWbdquLI6Nrsv+8Cx3U9/pWpzbvgudu3dYdG1269J8nNp3pjqOF5vOwcyw6NrMS30nuRF9J+l3sdnLbmsGRdemfT4yzlXte34yjx161d2/DIquzSq8WuS9V6p2z1Ozafo5H9UcE12duOP+Nu+4U/dMus9KV/95VlrG+rpzVjEkujqXu3OWPP8+/IS8ZLhlZy07JLo+m1LHshx58L2I9tnDtLuWPTy6QrP94dqo522YWXsx7zTo8OgabXZvRSQ/hvt3oCafvAPVJrA4xd0cEV2j5rd55wW3oW++PS4aAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKJ/ANlf1wmZYXVYAAAAAElFTkSuQmCC"
    },
};

const generate = async () => {
    const base64 = (await readFile(join(__dirname, '/img.base64'))).toString()
    db['0'].photo = base64
    db['1'].photo = base64
    db['2'].photo = base64
}

generate()

const server = () => {
    const app = express();
    app.use(express.json());
    app.use(cors());
    app.get('/', (req, res) => {
        return res.sendFile('/home/pieter/Desktop/gitlab/neocheckin/flutter-app/build/web/index.html');
    })
    app.use('/', express.static('/home/pieter/Desktop/gitlab/neocheckin/flutter-app/build/web'));

    app.get('/api/employee/:rfid', (req, res) => {
        const employeeId = req.params.rfid ?? '-1';
        if (db[employeeId]) return res.status(200).json({employee: db[employeeId]});
        
        return res.status(400).json({error: "employee does not exist"});
    });

    app.post('/api/employee/cardscanned', (req, res) => {
        const employeeRfid = req.body.employeeRfid ?? '-1';

        if (employeeRfid === '-1') 
            return res.status(400).json({ error: 'no rfid given' });
        if (!db[employeeRfid]) 
            return res.status(400).json({ error: 'user doesnt exist' });
        if (req.body.checkingIn === null || req.body.checkingIn === undefined) 
            return res.status(400).json({ error: 'checkingIn not given' })

        db[employeeRfid].working = req.body.checkingIn;
        
        return res.status(200).json({ employee: db[employeeRfid] });
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

        for (let department in employeesOrdered) {
            employeesOrdered[department].sort((a, b) => a.name.localeCompare(b.name))
        }

        return res.status(200).json({
            employees: employeesUnordered, 
            ordered: employeesOrdered, 
        });
    });

    app.get('/api/options/available', (req, res) => {

        return res.status(200).json({
            options: options, 
        });
    });

    app.listen(6000, () => {
        console.log('server started')
    })
}

server();