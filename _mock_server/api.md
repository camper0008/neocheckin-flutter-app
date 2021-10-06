# API Docs

## Models
Employee:
```ts
{
    name: string,
    flex: number,
    working: boolean,
    department: string,
    image: string
}
```

## Errors
In case of a status code >= 400 this will be the response instead.
```ts
{
    error_msg: string
}
```

## GET `/api/employee/:id`
### req:
Parameters:
```ts
{
    id: number
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
    employeeId: number,
    checkingIn: boolean
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