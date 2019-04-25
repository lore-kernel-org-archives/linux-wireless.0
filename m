Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37105C43218
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 22:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32115206BA
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 22:14:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=bowerswilkins.com header.i=@bowerswilkins.com header.b="XvL92DqI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731456AbfDYWOn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 18:14:43 -0400
Received: from mail-eopbgr40050.outbound.protection.outlook.com ([40.107.4.50]:32516
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731436AbfDYWOn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 18:14:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bowerswilkins.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YlxX1npCltul2djtNg6qLFOiGx6SH1E0ZPpes2xHWdo=;
 b=XvL92DqIbPBps3uU+uqkBRlErwva5tPlMfba/Qts9GcpTT6bs9xcjuLOuSvZMgtKe+cQBOHx2qhW+n/pbgqXKciVV5ULp+9wG2reJpfEl8o4gaH0dOPqB7gg0hznreLxEOHcknnUk/3yp6XVKDgX4Y627qog2DBOWY2XcMrooAU=
Received: from AM0PR04MB6065.eurprd04.prod.outlook.com (20.179.32.150) by
 AM0PR04MB4836.eurprd04.prod.outlook.com (20.177.41.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.16; Thu, 25 Apr 2019 22:14:40 +0000
Received: from AM0PR04MB6065.eurprd04.prod.outlook.com
 ([fe80::485d:efe5:102e:2989]) by AM0PR04MB6065.eurprd04.prod.outlook.com
 ([fe80::485d:efe5:102e:2989%3]) with mapi id 15.20.1835.010; Thu, 25 Apr 2019
 22:14:40 +0000
From:   Peter Oh <peter.oh@bowerswilkins.com>
To:     "b.K.il.h.u+tigbuh@gmail.com" <b.K.il.h.u+tigbuh@gmail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "wireless-regdb@lists.infradead.org" 
        <wireless-regdb@lists.infradead.org>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [wireless-regdb] [PATCH] wireless-regdb: Update regulatory rules
 for South Korea
Thread-Topic: [wireless-regdb] [PATCH] wireless-regdb: Update regulatory rules
 for South Korea
Thread-Index: AQHU5Mu2uUa12PzgWkyvey1kbLHWEqYyR1KAgBZangCAAcIOAIABWhkAgAHFvICAABsagA==
Date:   Thu, 25 Apr 2019 22:14:40 +0000
Message-ID: <6438cda3-169c-be2a-26f7-2ab0780040ea@bowerswilkins.com>
References: <1553711659-27600-1-git-send-email-peter.oh@bowerswilkins.com>
 <20190408124159.GC15126@ubuntu-xps13>
 <af4d49d9-fc9e-ebe3-20ab-edef6c12a2eb@bowerswilkins.com>
 <CAPuHQ=Grm6fEdP95jfj4zEXCr8be0PMOb9iv3oeYUt0y2Oeshw@mail.gmail.com>
 <b7af6387-a8bf-dfa0-b347-e58133d7298d@bowerswilkins.com>
 <CAPuHQ=EMmq7M7HHAO8iMrOgsgn9dAg=siUWXQMc0sA_8t_kBAg@mail.gmail.com>
In-Reply-To: <CAPuHQ=EMmq7M7HHAO8iMrOgsgn9dAg=siUWXQMc0sA_8t_kBAg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0083.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::24) To AM0PR04MB6065.eurprd04.prod.outlook.com
 (2603:10a6:208:139::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.oh@bowerswilkins.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.244.182.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8e46797-8344-4507-8a90-08d6c9cb6940
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM0PR04MB4836;
x-ms-traffictypediagnostic: AM0PR04MB4836:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM0PR04MB4836E24E906787415AEE0C7F993D0@AM0PR04MB4836.eurprd04.prod.outlook.com>
x-forefront-prvs: 0018A2705B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(346002)(396003)(376002)(39850400004)(199004)(189003)(3846002)(6306002)(31696002)(31686004)(6116002)(2906002)(53936002)(54906003)(86362001)(6512007)(102836004)(476003)(316002)(386003)(486006)(26005)(7736002)(76176011)(5024004)(66446008)(2616005)(478600001)(305945005)(6436002)(66476007)(15650500001)(14444005)(64756008)(25786009)(6246003)(66946007)(5660300002)(11346002)(53546011)(73956011)(6506007)(66556008)(4744005)(66066001)(4326008)(186003)(99286004)(446003)(97736004)(36756003)(14454004)(81166006)(81156014)(68736007)(6486002)(229853002)(93886005)(44832011)(8936002)(8676002)(71200400001)(52116002)(71190400001)(256004)(966005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4836;H:AM0PR04MB6065.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: bowerswilkins.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xv7XUNLJ7vj8Gg2WWjLlAP9dHm0iV11jal6Vh7FLfwx5LjHB7MBj9apxBEQoADa0WVF2/faJ7TM9yiaDHeBBxNsQQDEPray0sSVMcuEzvBPMR4r1thT5+cNY7yITOUq/D1MJMNYHlxKmfWVRrZn4JQtZ8WUCcyfzWPnYWlGbO55KAOhf8cTvAL/VGdghal2wvX62rgJOwMW6esqP3Vj1OgDeOExPpnAEbuiZ8+DpWPT2qERCyyYVjIpxDU3ZS4XBIejRee8pgI0ZMuUnUTbZI4paqb9NAi0eoFbJXquiMlBrlqTDS+CIVy4bo1qGJYN1BOtoytptHjb4rM+QfMmaprK4455NQ4AsJaB+u//CTZz91i3ilX70qKhcY9M0vt9jgTN2EnnLPSgh9Eu599BiG0l/lJzNMLVVnjil/hoQJTc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BDA8A757238A2D4C8400D269F7605CB3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bowerswilkins.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8e46797-8344-4507-8a90-08d6c9cb6940
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2019 22:14:40.2624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a75a45bb-4772-448f-a2c6-9d2413d86410
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4836
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDA0LzI1LzIwMTkgMDE6MzcgUE0sIGIuSy5pbC5oLnUrdGlnYnVoQGdtYWlsLmNvbSB3
cm90ZToNCj4gTm90ZSB0aGF0IGEgbGluayB0byB0aGUgMjAxNi0xMjQgZG9jdW1lbnQgaXMgc3Bl
Y2lmaWVkIGFzIHJlZmVyZW5jZSBpbg0KPiB0aGUgYWJvdmUgY29kZSAoY29udmVyc2lvbiBhbHNv
IGF0dGFjaGVkKSwgbm90IHRvIDIwMTYtMTI1LiBTaG91bGQgd2UNCj4gdXBkYXRlIHRoZSBsaW5r
PyBBbHRob3VnaCBzb21lIG9mIHRoZSBudW1iZXJzIHNlZW0gdG8gbWF0Y2gsIHRoZQ0KPiBkb2N1
bWVudHMgZGlmZmVyIGluIHN0cnVjdHVyZSBhbmQgLTEyNSBzZWVtcyB0byBoYW5kbGUgbW9yZSBi
YW5kcy4NCkkgZG9uJ3Qga25vdyB3aGVyZSB5b3UgZG93bmxvYWRlZCAyMDE2LTEyNCwgYnV0IHRo
ZXJlIGlzIG5vIGxpbmsgdG8gDQoyMDE2LTEyNCBvbmUgUkFBIHdlYnNpdGUuIA0KaHR0cHM6Ly93
d3cucnJhLmdvLmtyL2tvL3JlZmVyZW5jZS9sYXdMaXN0X3ZpZXcuZG8/bHdfc2VxPTU1Jmx3X3R5
cGU9MyZzZWFyY2hDb249Jmx3X3NlbGVjdD1BTEwmbHdfbW9kZWw9JnNlYXJjaFR4dD0NCkV2ZW4g
dGhvdWdoIDIwMTYtMTI0IGV4aXN0LCB3ZSBzaG91bGQgcmVmZXIgMjAxNi0xMjUgc2luY2UgaXQn
cyBsYXRlciANCnZlcnNpb24gdGhhbiAtMTI0Lg0KDQpUaGFua3MsDQpQZXRlcg0K
