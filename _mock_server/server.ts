import express from "express";
import cors from "cors";
import { stringify } from "querystring";

interface DbInterface {
    [key: string]: Worker;
}

interface Worker {
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

    app.get('/api/user/:userid', (req, res) => {
        const userid = req.params.userid;
        if (db[userid]) return res.status(200).json({"user": db[userid]});
        
        return res.status(400).json({"msg": "user does not exist"});
    });
    app.get('/api/workers', (req, res) => {

        const workers: {[department: string]: string[]} = {};

        const filtered = Object.entries(db).filter((user) => user[1].checkedIn);
        const mapped = filtered.map((entryKeyPair) => entryKeyPair[1]);

        for (let index in mapped) {
            const worker = mapped[index];
            if (!workers[worker.department]) {
                workers[worker.department] = [];
            }
            workers[worker.department].push(worker.name);
        }

        return res.status(200).json({"workers": workers});
    });

    app.post('/api/cardscanned', (req, res) => {
        const userid = req.body.userid

        if (!userid) return res.status(400).json({ msg: 'no userid given' });
        if (!db[userid]) return res.status(400).json({ msg: 'user doesnt exist' });
        
        db[userid].checkedIn = !db[userid].checkedIn;
        
        return res.status(200).json({ user: db[userid] });
    });

    app.listen(8079, () => {
        console.log('server started')
    })
}

server();