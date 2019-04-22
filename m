Return-Path: <SRS0=tUzJ=SY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9FCC10F11
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 18:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C797205C9
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 18:04:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=bowerswilkins.com header.i=@bowerswilkins.com header.b="bR85LHdT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbfDVSEN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Apr 2019 14:04:13 -0400
Received: from mail-eopbgr10063.outbound.protection.outlook.com ([40.107.1.63]:52165
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726260AbfDVSEN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Apr 2019 14:04:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bowerswilkins.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvTKgEK92BC1q1pkrS3ECBx/1pdFBy3+DQ4imjb6kpM=;
 b=bR85LHdTPCELpei24BdO1JxuboeG/eSpnes4JL6bTeEmRMa8PSHz5j2aVZ+sa9FAsQiVfHaSjxjRi4yzugyM69QmtAnasBMN9yG2jdB9T9pzHmnVTQT320+bcPp62SxXg16vqwJEfNTAibKfwVhjfO4Ps6xiR5PcPJvycNxpEIo=
Received: from AM0PR04MB6065.eurprd04.prod.outlook.com (20.179.32.150) by
 AM0PR04MB6689.eurprd04.prod.outlook.com (20.179.255.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.16; Mon, 22 Apr 2019 18:04:09 +0000
Received: from AM0PR04MB6065.eurprd04.prod.outlook.com
 ([fe80::1599:23e7:e53e:fe32]) by AM0PR04MB6065.eurprd04.prod.outlook.com
 ([fe80::1599:23e7:e53e:fe32%2]) with mapi id 15.20.1813.017; Mon, 22 Apr 2019
 18:04:09 +0000
From:   Peter Oh <peter.oh@bowerswilkins.com>
To:     Seth Forshee <seth.forshee@canonical.com>
CC:     "wireless-regdb@lists.infradead.org" 
        <wireless-regdb@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [wireless-regdb] [PATCH] wireless-regdb: Update regulatory rules
 for South Korea
Thread-Topic: [wireless-regdb] [PATCH] wireless-regdb: Update regulatory rules
 for South Korea
Thread-Index: AQHU5Mu2uUa12PzgWkyvey1kbLHWEqYyR1KAgBZangA=
Date:   Mon, 22 Apr 2019 18:04:09 +0000
Message-ID: <af4d49d9-fc9e-ebe3-20ab-edef6c12a2eb@bowerswilkins.com>
References: <1553711659-27600-1-git-send-email-peter.oh@bowerswilkins.com>
 <20190408124159.GC15126@ubuntu-xps13>
In-Reply-To: <20190408124159.GC15126@ubuntu-xps13>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0033.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::46) To AM0PR04MB6065.eurprd04.prod.outlook.com
 (2603:10a6:208:139::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.oh@bowerswilkins.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.244.182.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebcee451-ad5e-4d73-c8f5-08d6c74cead0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM0PR04MB6689;
x-ms-traffictypediagnostic: AM0PR04MB6689:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM0PR04MB668936A020124FAADD4F2CC499220@AM0PR04MB6689.eurprd04.prod.outlook.com>
x-forefront-prvs: 00159D1518
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(136003)(376002)(396003)(366004)(346002)(189003)(199004)(5660300002)(36756003)(66066001)(478600001)(305945005)(53936002)(25786009)(7736002)(6512007)(31696002)(86362001)(4326008)(6246003)(14454004)(6306002)(14444005)(966005)(44832011)(256004)(97736004)(186003)(15650500001)(54906003)(31686004)(316002)(2906002)(99286004)(81166006)(3846002)(386003)(6506007)(53546011)(76176011)(6116002)(102836004)(4744005)(229853002)(64756008)(66446008)(8676002)(446003)(6436002)(6486002)(486006)(11346002)(2616005)(476003)(71200400001)(71190400001)(6916009)(52116002)(66556008)(66476007)(73956011)(81156014)(26005)(8936002)(66946007)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB6689;H:AM0PR04MB6065.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: bowerswilkins.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nOfWMq0Knq1tJDJpnhsUobm1B0z8yBNx+R/73I20VQ3oy9ry1myDrH/EnIUkUNfGBXV+yZU3roNMNOO3BmKVzNSt9PmTrzU9wqKSG4omHjGtvKLcmbUB3rMP2P00hvawGZolF4juG9fHyvmKOWsz51Wh/qa9OzSsW0KpZQEX+oc4JIX4kSvvhNDg4exQd7bAZ4XdRjJISfWU9RgVpUwaH3lm1pLquuG4iZe/quivC+7N6ZOjHNXdnA0qQ8clkVzMyfOyhpgosJuNkMg/6tx0PGqK3tty/R8qr7UE+Kn3LMqeX/wu0btQND3sGJEKAL/iXyTgmzbBwYgB8SSoyIxExP9Ie+0pobsLn1711holJtU3yexany2YbnZIZjE9+EnwnHhdnGRQhC5fp3BrGqCnF3TRxGJfS0PcofToVnj/9+w=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62B8A4A83EEC9847BFF09AEF38E1DBEF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bowerswilkins.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebcee451-ad5e-4d73-c8f5-08d6c74cead0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2019 18:04:09.6711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a75a45bb-4772-448f-a2c6-9d2413d86410
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6689
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDA0LzA4LzIwMTkgMDU6NDEgQU0sIFNldGggRm9yc2hlZSB3cm90ZToNCj4gT24gV2Vk
LCBNYXIgMjcsIDIwMTkgYXQgMDY6MzQ6MjlQTSArMDAwMCwgUGV0ZXIgT2ggd3JvdGU6DQo+PiBG
cm9tOiBQZXRlciBPaCA8cGV0ZXIub2hAYm93ZXJzd2lsa2lucy5jb20+DQo+Pg0KPj4gVXBkYXRl
IHBvd2VyIGxpbWl0IGFzIGRvY3VtZW50ZWQgaW46DQo+PiBodHRwczovL3d3dy5ycmEuZ28ua3Iv
RmlsZURvd25Tdmw/ZmlsZV90eXBlPUxBV0tSJmZpbGVfcGFyZW50c2VxPTU0JmZpbGVfc2VxPTI3
DQo+PiB3aGljaCByZXZpc2VkIG9uIE5vdmVtYmVyIDMwLCAyMDE2Lg0KPj4NCj4+IFNpZ25lZC1v
ZmYtYnk6IFBldGVyIE9oIDxwZXRlci5vaEBib3dlcnN3aWxraW5zLmNvbT4NCj4gSSB1c3VhbGx5
IHRyeSB0byBjaGVjayB0aGUgY2hhbmdlcyBhZ2FpbnN0IHRoZSBkb2N1bWVudHMsIGJ1dCBpbiB0
aGlzDQo+IGNhc2UgSSBoYXZlbid0IGJlZW4gYWJsZSB0byBnZXQgYW55IEVuZ2xpc2ggdHJhbmxh
dGlvbiBmb3IgdGhlIGRvY3VtZW50DQo+IChvciBldmVuIHZpZXcgdGhlIGNvbnRlbnRzIGl0IGlu
IGFueSBtZWFuaW5nZnVsIHdheSkuIEkgZG9uJ3Qgc3VwcG9zZQ0KPiB5b3Uga25vdyB3aGVyZSB0
byBmaW5kIGFuIEVuZ2xpc2ggdmVyc2lvbiBvZiB0aGUgZG9jdW1lbnQ/DQpVbmZvcnR1bmF0ZWx5
IHRoZXJlIGlzIG5vIEVuZ2xpc2ggdmVyc2lvbiBvZiB0aGUgZG9jLiBUeXBpY2FsbHkgSSB1c2Ug
DQpHb29nbGUgdHJhbnNsYXRpb24gdG8gdW5kZXJzdGFuZCBmb3JlaWduIGxhbmd1YWdlLCBidXQg
aW4gdGhpcyBjYXNlIEkgDQpjb250YWN0ZWQgdGhhdCBkZXBhcnRtZW50IHBlcnNvbmFsbHkgdmlh
IHBob25lIGNhbGwgYW5kIGRpcmVjdGVkIHRvIHRoZSANCmRvYyBieSB0aGUgcmVzcG9uc2libGUg
cGVyc29uIGZyb20gdGhlIGRlcGFydG1lbnQuDQoNClRoYW5rcywNClBldGVyDQo=
