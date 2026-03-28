# PostgreSQL High Availability & Disaster Recovery Lab

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue?logo=postgresql)
![Ubuntu](https://img.shields.io/badge/OS-Ubuntu_24.04-orange?logo=ubuntu)
![AWS](https://img.shields.io/badge/Cloud-AWS_EC2-232F3E?logo=amazon-aws)

This repository demonstrates a production-grade **Primary-Secondary Database Architecture**. It covers the complete lifecycle of data reliability: from automated local backups to real-time streaming replication on the AWS Cloud.

## 🏗 System Architecture

The project bridges a local development environment with the public cloud to simulate a geo-redundant disaster recovery site.

- **Primary Node:** Local Ubuntu 24.04 (Master)
- **Secondary Node:** AWS EC2 Instance (Hot Standby)
- **Network Bridge:** Secure SSH Reverse Tunnel (Mapping AWS:5435 -> Local:5432)
- **Replication Type:** Asynchronous Streaming Replication

---

## 🛠 Key Features

### 1. Automated Backup & Retention
I developed a Bash utility (`scripts/db_backup.sh`) that automates logical exports.
* **Point-in-Time Recovery:** Integrated with `crontab` for scheduled snapshots.
* **Storage Optimization:** Automatic 7-day rolling retention policy to prevent disk exhaustion.

### 2. Disaster Simulation (Chaos Engineering)
To validate the "Recovery Time Objective" (RTO), I simulated a catastrophic failure:
* **The Crash:** Manually purged the entire PostgreSQL data directory and dropped the cluster.
* **The Recovery:** Successfully re-initialized the database cluster and restored 100% of the data using the latest SQL dump.

### 3. Cross-Site Streaming Replication
Bridging the local environment to AWS EC2 without opening dangerous firewall ports:
* **Tunneling:** Used an **SSH Reverse Tunnel** to allow the AWS Replica to "see" the local Primary behind a NAT.
* **Security:** Implemented MD5 authentication via a dedicated `replication_user`.
* **Failover:** Executed a manual failover test, promoting the AWS Secondary to a Read-Write Master using `pg_promote()`.

---

## 📂 Project Structure

```text
.
├── scripts/
│   └── db_backup.sh       # Production backup & retention script
├── configs/
│   ├── postgresql.conf    # Replication & Listen settings
│   └── pg_hba.conf        # Security & Authentication rules
└── README.md              # Project documentation
