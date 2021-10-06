# Scenarios

A library supporting fast prototyping for iOS Projects.

# Introduction

## Challenges of mobile frontend development

- Stories with multiple requirements.
- Multiple stakeholders (backend devs, designers, QAs, PMs, SMs, Testers, CTO, CEO ….).
- Multiple environments, configurations.
- Working on multiple features in parallel.
- Demonstrating multiple states for UI components.
- Mobile app deployment is complicated.
- Continuous delivery.

![problem](Assets/problem.jpg)

## Scenario-driven development

- Scenarios is a system supporting continuously delivering of incremental updates for mobile app frontends.
- Targeting early feedback loop from all stakeholders.
- Avoiding the need to deliver multiple apps for different purposes.
- Easing parallelism between feature teams.
- Supporting automated tests.
- Extensible, new types of scenarios can be created to accommodate different stakeholders: prototype scenario, design system scenario, accessibility scenario, etc ...

![scenario](Assets/scenario.jpg)

## Recommended modular architecture

![architecture](Assets/architecture.jpg)

## Sample app

There is a sample app inside this repository. The app fetches the list of popular Swift repositories from Github and display them in a UITableView.

The app will contain all scenarios for each of the components, as well as a mocking and a production environment scenarios.

https://user-images.githubusercontent.com/478757/136145086-85e43b43-9479-432a-b308-67533b51adad.mp4


# Getting Started

Please check out the Sample project.

# License

MIT
