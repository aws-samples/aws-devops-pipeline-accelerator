import * as cdk from "aws-cdk-lib";
import * as ec2 from "aws-cdk-lib/aws-ec2";
import * as iam from "aws-cdk-lib/aws-iam";

import { Construct } from "constructs";
// import * as sqs from 'aws-cdk-lib/aws-sqs';

export class CustomInfraStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // 👇 parameter of type String
    const instanceName = new cdk.CfnParameter(this, "instanceName", {
      type: "String",
      description: "The name of the Dynamodb table",
    }).valueAsString;
    console.log("ec2_name", instanceName.toString);

    //key name
    const keyName = new cdk.CfnParameter(this, "keyName", {
      type: "String",
      description: "The name of the AWS pem key name",
    }).valueAsString;

    const vpc = new ec2.Vpc(this, "cdk-vpc", {
      cidr: "10.0.0.0/16",
      natGateways: 1,
      maxAzs: 3,
      subnetConfiguration: [
        {
          name: "private-subnet-1",
          subnetType: ec2.SubnetType.PRIVATE_WITH_EGRESS,
          cidrMask: 24,
        },
        {
          name: "public-subnet-1",
          subnetType: ec2.SubnetType.PUBLIC,
          cidrMask: 24,
        },
        {
          name: "isolated-subnet-1",
          subnetType: ec2.SubnetType.PRIVATE_ISOLATED,
          cidrMask: 28,
        },
      ],
    });

    // 👇 Create a SG for a web server
    const webserverSG = new ec2.SecurityGroup(this, "web-server-sg", {
      vpc,
      allowAllOutbound: true,
      description: "security group for a web server",
    });

    webserverSG.addIngressRule(
      ec2.Peer.anyIpv4(),
      ec2.Port.tcp(22),
      "allow SSH access from anywhere"
    );

    webserverSG.addIngressRule(
      ec2.Peer.anyIpv4(),
      ec2.Port.tcp(80),
      "allow HTTP traffic from anywhere"
    );

    webserverSG.addIngressRule(
      ec2.Peer.anyIpv4(),
      ec2.Port.tcp(443),
      "allow HTTPS traffic from anywhere"
    );

    webserverSG.addIngressRule(
      ec2.Peer.ipv4("123.123.123.123/16"),
      ec2.Port.allIcmp(),
      "allow ICMP traffic from a specific IP range"
    );

    const cdkrole = iam.Role.fromRoleArn(this, 'Role', 'arn:aws:iam::316172404479:role/cdk-role', {
      mutable: false,
    });
    var name = "test-value";

    const ec2Instance = new ec2.Instance(this, "ec2", {
      vpc,
      vpcSubnets: {
        subnetType: ec2.SubnetType.PUBLIC,
      },
      role: cdkrole,
      instanceName: instanceName,
      securityGroup: webserverSG,
      instanceType: ec2.InstanceType.of(
        ec2.InstanceClass.BURSTABLE2,
        ec2.InstanceSize.MICRO
      ),
      machineImage: new ec2.AmazonLinuxImage({
        generation: ec2.AmazonLinuxGeneration.AMAZON_LINUX_2,
      }),
      keyName: keyName,
    });
  }
}

/* cdk deploy CustomInfraStack --parameters instanceName=ec2_name --parameters keyName=mayuri-n-virginia-focus-grp */
