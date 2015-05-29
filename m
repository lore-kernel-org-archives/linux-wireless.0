Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8338 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756459AbbE2PX6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 11:23:58 -0400
From: Avinash Patil <patila@marvell.com>
To: =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, "Xinming Hu" <huxm@marvell.com>
Subject: RE: [PATCHv3 09/16] mwifiex: add sta_list firmware command
Date: Fri, 29 May 2015 15:23:47 +0000
Message-ID: <a66e3a258cd5435ba69da9ff025a035a@SC-EXCH02.marvell.com> (sfid-20150529_172401_364467_833E6AB1)
References: <1432918598-27769-1-git-send-email-patila@marvell.com>
	<1432918598-27769-10-git-send-email-patila@marvell.com>
 <87382fh9ln.fsf@nemi.mork.no>
In-Reply-To: <87382fh9ln.fsf@nemi.mork.no>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCasO4cm4gTW9yayBbbWFpbHRv
OmJqb3JuQG1vcmsubm9dDQo+IFNlbnQ6IEZyaWRheSwgTWF5IDI5LCAyMDE1IDU6MzYgUE0NCj4g
VG86IEF2aW5hc2ggUGF0aWwNCj4gQ2M6IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsg
QW1pdGt1bWFyIEthcndhcjsgQ2F0aHkgTHVvOyBYaW5taW5nIEh1DQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0h2MyAwOS8xNl0gbXdpZmlleDogYWRkIHN0YV9saXN0IGZpcm13YXJlIGNvbW1hbmQNCj4g
DQo+IEF2aW5hc2ggUGF0aWwgPHBhdGlsYUBtYXJ2ZWxsLmNvbT4gd3JpdGVzOg0KPiANCj4gPiAg
CQljYXNlIEhvc3RDbWRfQ01EX1VBUF9CU1NfU1RPUDoNCj4gPiAgCQljYXNlIEhvc3RDbWRfQ01E
X1VBUF9TVEFfREVBVVRIOg0KPiA+ICAJCWNhc2UgSE9TVF9DTURfQVBDTURfU1lTX1JFU0VUOg0K
PiA+ICsJCWNhc2UgSE9TVENNRF9DTURfVUFQX1NUQV9MSVNUOg0KPiANCj4gDQo+IEp1c3Qgd29u
ZGVyaW5nLCBub3QgcmVhbGx5IG9iamVjdGluZy4uLi4gQnV0IHdvdWxkbid0IGl0IGJlIG5pY2Ug
d2l0aCBzb21lDQo+IGNvbnNpc3RlbmN5IGhlcmU/DQo+IA0KPg0KDQpUaGFua3MgZm9yIHJldmll
dy4uLndpbGwgbW9kaWZ5IGNhc2UgSE9TVENNRF9DTURfVUFQX1NUQV9MSVNUIHRvIGNhc2UgSE9T
VF9DTURfQVBDTURfU1RBX0xJU1Qgc28gYXMga2VlcCBjb25zaXN0ZW5jeSB3aXRoIFNZU19SRVNF
VC4NCiANCj4gQmrDuHJuDQoNCi1BdmluYXNoDQo=
