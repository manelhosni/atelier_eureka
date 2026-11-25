const app = require('./app');
const Eureka = require('eureka-js-client').Eureka;

const PORT = process.env.PORT || 8083;

// Configuration du client Eureka
const eurekaClient = new Eureka({
  instance: {
    instanceId: `localhost:meeting:${PORT}`,
    app: 'MEETING',
    hostName: 'localhost',
    ipAddr: '127.0.0.1',
    port: {
      '$': parseInt(PORT, 10),
      '@enabled': true,
    },
    vipAddress: 'MEETING',
    dataCenterInfo: {
      '@class': 'com.netflix.appinfo.InstanceInfo$DefaultDataCenterInfo',
      name: 'MyOwn',
    },
    statusPageUrl: `http://localhost:${PORT}/info`,
    healthCheckUrl: `http://localhost:${PORT}/health`,
    homePageUrl: `http://localhost:${PORT}/`,
  },
  eureka: {
    host: 'localhost',
    port: 8761,
    servicePath: '/eureka/apps/',
  },
});

app.listen(PORT, () => {
  console.log(`meeting microservice running on http://localhost:${PORT}`);
  console.log(`Swagger UI: http://localhost:${PORT}/swagger-ui`);

  // S'enregistrer dans Eureka apres le demarrage
  eurekaClient.start((error) => {
    if (error) {
      console.error('Eureka registration failed:', error);
    } else {
      console.log('Registered with Eureka');
    }
  });
});

// Desenregistrement propre a l'arret
process.on('SIGINT', () => {
  eurekaClient.stop(() => {
    console.log('Deregistered from Eureka');
    process.exit();
  });
});
