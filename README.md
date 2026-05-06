# 📚 Nothing Hill Bookstore

A web-based enterprise bookstore application built with Java EE, developed using NetBeans IDE and deployed on Apache GlassFish Server. This project demonstrates enterprise application development using EJB architecture.

---

## ✨ Preview

> _Add a screenshot here — drag an image into GitHub_

---

## 🚀 Features

- Browse and search the bookstore catalogue
- Enterprise-grade architecture using EJB (Enterprise JavaBeans)
- Separation of concerns with EAR project structure (EJB module + WAR module)
- Deployed on Apache GlassFish Server

---

## 🛠️ Tech stack

| Technology | Role |
|-----------|------|
| Java EE | Core backend language |
| EJB (Enterprise JavaBeans) | Business logic layer |
| JSP / HTML / CSS | Frontend views |
| Apache GlassFish | Application server |
| NetBeans IDE | Development environment |

---

## 📂 Project structure

```
nothing-hill-bookstore/
├── NothingHillEAR-ejb/     ← EJB module (business logic)
├── NothingHillEAR-war/     ← WAR module (web layer / UI)
├── NothingHillShared/      ← Shared classes
├── src/conf/               ← Configuration files
├── build/                  ← Compiled output
├── dist/                   ← Deployable EAR file
└── build.xml               ← Ant build script
```

---

## ⚙️ How to run locally

1. Install [NetBeans IDE](https://netbeans.apache.org/) with Java EE support
2. Install and configure [GlassFish Server](https://javaee.github.io/glassfish/)
3. Clone the repo:
   ```bash
   git clone https://github.com/DamiaYuhanes/nothing-hill-bookstore.git
   ```
4. Open the project in NetBeans: `File → Open Project`
5. Right-click the project → `Run` (NetBeans will deploy to GlassFish automatically)
6. Open your browser and navigate to the local GlassFish URL (usually `http://localhost:8080/NothingHillEAR-war/`)

---

## 💡 What I learned

- Enterprise Java application architecture (EAR = EJB + WAR)
- Deploying Java EE apps on GlassFish server
- Working with NetBeans for enterprise project management
- Separating business logic from presentation layer

---

## 👩‍💻 Author

**Damia Yuhanes** — Software Engineering Student @ UniKL

[![GitHub](https://img.shields.io/badge/GitHub-DamiaYuhanes-181717?style=flat-square&logo=github)](https://github.com/DamiaYuhanes)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
