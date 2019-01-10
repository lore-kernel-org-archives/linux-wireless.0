Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F32CC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 18:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D3862064C
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 18:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbfAJSCF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 13:02:05 -0500
Received: from mga05.intel.com ([192.55.52.43]:27754 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729480AbfAJSCF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 13:02:05 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2019 10:02:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,462,1539673200"; 
   d="scan'208";a="115802164"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga008.fm.intel.com with ESMTP; 10 Jan 2019 10:02:04 -0800
Received: from fmsmsx123.amr.corp.intel.com (10.18.125.38) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 10 Jan 2019 10:02:04 -0800
Received: from hasmsx107.ger.corp.intel.com (10.184.198.27) by
 fmsmsx123.amr.corp.intel.com (10.18.125.38) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 10 Jan 2019 10:02:04 -0800
Received: from hasmsx112.ger.corp.intel.com ([169.254.11.151]) by
 hasmsx107.ger.corp.intel.com ([169.254.2.13]) with mapi id 14.03.0415.000;
 Thu, 10 Jan 2019 20:02:00 +0200
From:   "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>,
        "kyle@infradead.org" <kyle@infradead.org>,
        "jwboyer@kernel.org" <jwboyer@kernel.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: Re: pull request: iwlwifi firmware updates 2018-12-30
Thread-Topic: pull request: iwlwifi firmware updates 2018-12-30
Thread-Index: AQHUoBa3x++UKjxcNkWdkej42N9fkaWou3KA
Date:   Thu, 10 Jan 2019 18:01:59 +0000
Message-ID: <35b2d5c1f660bff613f77ec7405db284587c62d3.camel@intel.com>
References: <1546157106.3213.3.camel@intel.com>
In-Reply-To: <1546157106.3213.3.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.8.136]
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFCDA839A695104DA30F6D366E10BA85@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gU3VuLCAyMDE4LTEyLTMwIGF0IDEwOjA1ICswMjAwLCBFbW1hbnVlbCBHcnVtYmFjaCB3cm90
ZToNCj4gSGksDQo+IA0KPiBUaGlzIGNvbnRhaW5zIGEgZml4IGZvcjoNCj4gaHR0cHM6Ly9idWd6
aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0yMDIwODUNCj4gDQo+IFBsZWFzZSBwdWxs
Lg0KPiANCg0KDQpLaW5kIHJlbWluZGVyIDopDQoNCj4gDQo+IFRoYW5rcyENCj4gDQo+IFRoZSBm
b2xsb3dpbmcgY2hhbmdlcyBzaW5jZSBjb21taXQNCj4gMGYyMmM4NTI3NDM5ZWFhZjVjM2ZjZjg3
YjMxYzg5NDQ1YjZmYTg0ZDoNCj4gDQo+ICAgUmV2ZXJ0ICJhbWRncHU6IHVwZGF0ZSB2ZWdhMTAg
ZncgZm9yIDE4LjUwIHJlbGVhc2UiICgyMDE4LTEyLTE4DQo+IDE1OjM4OjUzIC0wNTAwKQ0KPiAN
Cj4gYXJlIGF2YWlsYWJsZSBpbiB0aGUgR2l0IHJlcG9zaXRvcnkgYXQ6DQo+IA0KPiAgIGdpdDov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9pd2x3aWZpL2xpbnV4LQ0K
PiBmaXJtd2FyZS5naXQgdGFncy9pd2x3aWZpLWZ3LTIwMTgtMTItMzANCj4gDQo+IGZvciB5b3Ug
dG8gZmV0Y2ggY2hhbmdlcyB1cCB0bw0KPiBiNzI3NzM5MTg3ZjA1ZTE2ZTBiODRkYTI5NjE1ZjE2
NWUxMDJhMmY2Og0KPiANCj4gICBpd2x3aWZpOiB1cGRhdGUgZmlybXdhcmVzIGZvciA5MDAwIHNl
cmllcyAoMjAxOC0xMi0zMCAwODozODowMQ0KPiArMDIwMCkNCj4gDQo+IC0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gdXBk
YXRlcyBmb3IgLTQzLnVjb2RlIGZvciA5MjYwIGFuZCA5MDAwDQo+IA0KPiAtLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IEVt
bWFudWVsIEdydW1iYWNoICgxKToNCj4gICAgICAgaXdsd2lmaTogdXBkYXRlIGZpcm13YXJlcyBm
b3IgOTAwMCBzZXJpZXMNCj4gDQo+ICBXSEVOQ0UgICAgICAgICAgICAgICAgICAgICAgICAgICAg
fCAgIDQgKystLQ0KPiAgaXdsd2lmaS05MDAwLXB1LWIwLWpmLWIwLTQzLnVjb2RlIHwgQmluIDI1
NDM1MzIgLT4gMjU0MzUzNiBieXRlcw0KPiAgaXdsd2lmaS05MjYwLXRoLWIwLWpmLWIwLTQzLnVj
b2RlIHwgQmluIDI1NTgxNzIgLT4gMjU1ODE3NiBieXRlcw0KPiAgMyBmaWxlcyBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvV0hFTkNF
IGIvV0hFTkNFDQo+IGluZGV4IGFjZDkzY2JjNjgwOC4uOTVkZmQwMGNjOTU1IDEwMDY0NA0KPiAt
LS0gYS9XSEVOQ0UNCj4gKysrIGIvV0hFTkNFDQo+IEBAIC0xMDEzLDcgKzEwMTMsNyBAQCBGaWxl
OiBpd2x3aWZpLTkwMDAtcHUtYjAtamYtYjAtNDEudWNvZGUNCj4gIFZlcnNpb246IDQxLmZjMWE3
YWVhLjANCj4gIA0KPiAgRmlsZTogaXdsd2lmaS05MDAwLXB1LWIwLWpmLWIwLTQzLnVjb2RlDQo+
IC1WZXJzaW9uOiA0My5jNzMxMTRiMy4wDQo+ICtWZXJzaW9uOiA0My45NWViNGU5Ny4wDQo+ICAN
Cj4gIEZpbGU6IGl3bHdpZmktOTI2MC10aC1iMC1qZi1iMC0zMy51Y29kZQ0KPiAgVmVyc2lvbjog
MzMuNjEwMjk0LjANCj4gQEAgLTEwMjgsNyArMTAyOCw3IEBAIEZpbGU6IGl3bHdpZmktOTI2MC10
aC1iMC1qZi1iMC00MS51Y29kZQ0KPiAgVmVyc2lvbjogNDEuZmMxYTdhZWEuMA0KPiAgDQo+ICBG
aWxlOiBpd2x3aWZpLTkyNjAtdGgtYjAtamYtYjAtNDMudWNvZGUNCj4gLVZlcnNpb246IDQzLmM3
MzExNGIzLjANCj4gK1ZlcnNpb246IDQzLjk1ZWI0ZTk3LjANCj4gIA0KPiAgTGljZW5jZTogUmVk
aXN0cmlidXRhYmxlLiBTZWUgTElDRU5DRS5pd2x3aWZpX2Zpcm13YXJlIGZvciBkZXRhaWxzDQo+
ICANCj4gZGlmZiAtLWdpdCBhL2l3bHdpZmktOTAwMC1wdS1iMC1qZi1iMC00My51Y29kZSBiL2l3
bHdpZmktOTAwMC1wdS1iMC0NCj4gamYtYjAtNDMudWNvZGUNCj4gaW5kZXggZjVjZjVmMzFiOTIw
Li5hZTYxMDI2M2VhNTYgMTAwNjQ0DQo+IEJpbmFyeSBmaWxlcyBhL2l3bHdpZmktOTAwMC1wdS1i
MC1qZi1iMC00My51Y29kZSBhbmQgYi9pd2x3aWZpLTkwMDAtDQo+IHB1LWIwLWpmLWIwLTQzLnVj
b2RlIGRpZmZlcg0KPiBkaWZmIC0tZ2l0IGEvaXdsd2lmaS05MjYwLXRoLWIwLWpmLWIwLTQzLnVj
b2RlIGIvaXdsd2lmaS05MjYwLXRoLWIwLQ0KPiBqZi1iMC00My51Y29kZQ0KPiBpbmRleCAyOTA5
M2Q1ZDU5MmYuLjNkNWNjZDYzMjM0MSAxMDA2NDQNCj4gQmluYXJ5IGZpbGVzIGEvaXdsd2lmaS05
MjYwLXRoLWIwLWpmLWIwLTQzLnVjb2RlIGFuZCBiL2l3bHdpZmktOTI2MC0NCj4gdGgtYjAtamYt
YjAtNDMudWNvZGUgZGlmZmVyDQo=
