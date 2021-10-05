import express from "express";
import cors from "cors";

interface DbInterface {
    [key: string]: {
        username: string,
        flex: number,
        checkedIn: boolean,
    }
}

const db: DbInterface = {
    "user": {
        username: 'testuser',
        flex: 50000,
        checkedIn: false,
    },
    "user2": {
        username: 'testuser2',
        flex: 420,
        checkedIn: true,
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