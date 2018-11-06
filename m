Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F69C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 05:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 275DB2081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 05:56:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="vpTvq2wU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 275DB2081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbeKFPUI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 10:20:08 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:19721 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729326AbeKFPUI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 10:20:08 -0500
X-IronPort-AV: E=Sophos;i="5.54,470,1534834800"; 
   d="scan'208";a="23664231"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Nov 2018 22:56:36 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 5 Nov 2018 22:56:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GqDhCn4PeriRryDtN0/eRnmcgaMdWv1W2f1mV3EJkU=;
 b=vpTvq2wU/8HsKXuapre5h9ZIFQrHBnRk/9K9m/tb76KJe2q+fHxZrguv5CJJi4OXoeQJzyvcHnzQ3itMUOeOlyfW/i8kuQVsLbO3KPX1dzXtwt9uyyKBONfwhlWe2up5MM+HJXX9f28wF5jajKXg8uWEA0pcYmPewjbYIFJCvLk=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2533.namprd11.prod.outlook.com (52.135.226.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.20; Tue, 6 Nov 2018 05:56:33 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.032; Tue, 6 Nov 2018
 05:56:33 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <gregkh@linuxfoundation.org>
CC:     <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <Ganesh.Krishna@microchip.com>, <Adham.Abozaeid@microchip.com>,
        <Aditya.Shankar@microchip.com>, <johannes@sipsolutions.net>
Subject: Re: [PATCH] staging: wilc1000: update wilc1000 driver maintainer ids
Thread-Topic: [PATCH] staging: wilc1000: update wilc1000 driver maintainer ids
Thread-Index: AQHUcBTo0t5lHo2vaUeorSzybHvUTaVBRAqAgAEGroA=
Date:   Tue, 6 Nov 2018 05:56:33 +0000
Message-ID: <4950d879-91a4-91ac-8d8f-d1667fe7e0bd@microchip.com>
References: <1540878731-7326-1-git-send-email-ajay.kathat@microchip.com>
 <20181105141611.GA21485@kroah.com>
In-Reply-To: <20181105141611.GA21485@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0081.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::21)
 To BYAPR11MB2567.namprd11.prod.outlook.com (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [49.205.216.87]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2533;6:EZsrNOitMmoXIyUIAV2WQIAgAHlD4d0dD5NrtE4z+6GnHzQAC2O/7E3nf43s2pUCOLZllZhepmSkkPOp+knhZxe4zkcNAub0R+igwwbBRjynWQBAi/+UlqLxr0U4tsTjjY2bAzrH9N9+5M5e/P0nRVwZaE9Zpid1W5to2HXH7VulwzA/Qp10J6kcDvq7Pw3VC5DjOpshVEtH4JlBgUBdk+LHej58S5IkhRAXiWVMcgfDiQo4KUngC/PUfz8/AUsppwdLXQiPYLUFbM3BBLpPFRigiPzms5jNPfJKjsAxDU0gH633JPqxKRpDzz7+9ftELjhbuLyECeoEQ/89ohd4tOjK2JbR2H1l/NxbYLBHcsDQ2Ni6PD7+h2zMmHvDPaIQfT69dfOfmkDqfMFySGLaxZsyW7sk7kAd3+uv/Bl8Vwz0YFJaMzveZ+hMgbvddSBhBsEW4aAh9ZBWR7Il8FW4XA==;5:7nBDI2LGR7m1HNq3HiYZLpKSE0MLvtVfLLRAdCnqz6J6xBXV9dajRIxp4Fyu26BA5z/+ieRka7YZ0ZMwkYQFUpQy4U80Nlpb6aF/QxOXYeDmfYHN4oLrYrQHSc99/iJ6Y9a1rtNsl3JiY4jgJWsJRRqh0a9//oBZyOdmZW4vi3U=;7:HQjD1lfydvSTyvKkosdXo/rrGxVqjgWjOmoPLS6V5JhYzNbFt+ZFQqvjknoqgp7kYMqIoUPhUBntl7uTU0diz9A9Hv8aFqitAM2kdidT+alTIjfi/mSgwqTXkIhWDzjpivshWuEVkskUCU3bR2EE+g==
x-ms-office365-filtering-correlation-id: 7dd32c35-bb6e-4bec-693a-08d643ac9a74
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2533;
x-ms-traffictypediagnostic: BYAPR11MB2533:
x-microsoft-antispam-prvs: <BYAPR11MB25334A75E6C6B8EFA007ED1AE3CB0@BYAPR11MB2533.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231382)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123560045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2533;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2533;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(376002)(136003)(346002)(366004)(189003)(199004)(14454004)(68736007)(97736004)(6116002)(3846002)(71200400001)(71190400001)(78486014)(6436002)(105586002)(14444005)(5660300001)(106356001)(6512007)(256004)(2906002)(6486002)(6916009)(316002)(31696002)(305945005)(7736002)(229853002)(54906003)(36756003)(86362001)(66066001)(15650500001)(53546011)(486006)(446003)(11346002)(476003)(72206003)(4326008)(186003)(478600001)(2616005)(99286004)(102836004)(8936002)(386003)(6506007)(26005)(25786009)(8676002)(52116002)(76176011)(81166006)(81156014)(53936002)(6246003)(31686004)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2533;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: eK5dxGSTbRZzQxCEu3i4TvTVQf8Bpkb3qjsE9XLmAMUvDk8oeVtuQ22Io4vqRLymXLU4z/5+kpkC/c7UWlYtS62cSgDzAIVa0qnfOnL9C3sTTFHkRIxPPwCato9KJC3htVq8YxqE/SRmLquOkDL4THIbXxOwFitbgS+cpaDBQSGmF+zB/HvNBkxmEBvc8Tb4PdCmWra2LR1SPcfjyfsb9ZfUlb6gHEW0tws6iSDdxlYhwF/jCuV78NyHBtruqUg6CaFane7AQmbFkSUDkNovZEJF1yGevQ66af4y0XV/0uJmyCGxrMprXmVxbMSHM8xs/TWY9DUTZTnkigbmK1vu7m33zCvKLL5zaSIJzZp5doA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEDC2725A0917849A7246E1C6D00E920@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dd32c35-bb6e-4bec-693a-08d643ac9a74
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 05:56:33.1355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2533
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGkgR3JlZywNCg0KT24gMTEvNS8yMDE4IDc6NDYgUE0sIEdyZWcgS0ggd3JvdGU6DQo+IE9uIFR1
ZSwgT2N0IDMwLCAyMDE4IGF0IDA1OjUzOjQwQU0gKzAwMDAsIEFqYXkuS2F0aGF0QG1pY3JvY2hp
cC5jb20gd3JvdGU6DQo+PiBGcm9tOiBBamF5IFNpbmdoIDxhamF5LmthdGhhdEBtaWNyb2NoaXAu
Y29tPg0KPj4NCj4+IFdlIHdvdWxkIGxpa2UgdG8gdXBkYXRlIHRoZSBtYWludGFpbmVyIGVtYWls
IGlkJ3MgZm9yIHdpbGMxMDAwIGRyaXZlci4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBBamF5IFNp
bmdoIDxhamF5LmthdGhhdEBtaWNyb2NoaXAuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogQWRoYW0g
QWJvemFlaWQgPGFkaGFtLmFib3phZWlkQG1pY3JvY2hpcC5jb20+DQo+IEl0IHdvdWxkIGJlIGdv
b2QgdG8gZ2V0IHRoZSBjdXJyZW50IG1haW50YWluZXIncyBzaWduZWQgb2ZmIGJ5IG9uIHRoaXMN
Cj4gc28gSSBrbm93IHRoYXQgdGhleSBhbHNvIGFncmVlIHdpdGggdGhpcyBjaGFuZ2UuDQoNClN1
cmUsIEkgaGF2ZSBzdWJtaXR0ZWQgdGhpcyBwYXRjaCB3aXRoIGN1cnJlbnQgbWFpbnRhaW5lcidz
IGFncmVlbWVudC4NCkFzIHN1Z2dlc3RlZCwgSSB3aWxsIHNlbmQgdGhlIHVwZGF0ZWQgcGF0Y2gg
YnkgaW5jbHVkaW5nIGN1cnJlbnQNCm1haW50YWluZXJzIHNpZ25lZCBvZmYgdGFnLg0KDQpSZWdh
cmRzLA0KQWpheQ0KDQo=
