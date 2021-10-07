# API Docs

## Models
Employee:
```ts
{
    name: string,
    flex: number,
    working: boolean,
    department: string,
    photo: string // Base64 Image
}
```

Option:
```ts
{
    id: number,
    name: string
}
```

## Errors
In case of a status code >= 400 this will be the response instead.
```ts
{
    error: string
}
```

## GET `/api/employee/:id`
### req:
Parameters:
```ts
{
    id: string // rfid
}
```
### res:
```ts
{
    employee: Employee,
}
```

## POST `/api/employee/cardscanned`
### req:
```ts
{
    employeeId: string, // rfid
    checkingIn: boolean
    optionId: number // -1 if no option was selected, so you dont need a "default" option
}
```
### res:
```ts
{
    employee: Employee
}
```

## GET `/api/employees/working`
### req:
```ts
{}
```
### res:
```ts
{
    employees: Employee[],
    ordered: {
        [department: string]: Employee[]
    }
}
```

## GET `/api/options/available`
### req:
```ts
{}
```
### res:
```ts
{
    options: Option[],
}
```