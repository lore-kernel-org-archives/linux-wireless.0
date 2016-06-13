Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29065 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422893AbcFMNlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 09:41:03 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Vincent CESSON <vincent.cesson@smile.fr>
CC: Raymond Hayes <hayesr@google.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Shengzhen Li <szli@marvell.com>
Subject: RE: mwifiex+wpa_supplicant cannot set up WPA/WPA2 ADHOC
Date: Mon, 13 Jun 2016 13:40:49 +0000
Message-ID: <db092693c63a4a06ada95537e22d5abf@SC-EXCH04.marvell.com> (sfid-20160613_154108_099862_8A4C8F62)
References: <4eed6159efdc3f86e4f549bb31ce6a74@smile.fr>
 <CAKVVYBk2Rf6RMPW1uySq4M7LeFCRHBGipYdiOqwQSHxFNmst=A@mail.gmail.com>
 <053ed5ba9d69bc5e6f36ed7e95526663@smile.fr>
 <4fdb1514a02744ad9b8ac11b96e57130@SC-EXCH04.marvell.com>
 <404feff5a5bca118ba53b69301700e2f@smile.fr>
In-Reply-To: <404feff5a5bca118ba53b69301700e2f@smile.fr>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgVmluY2VudCwNCg0KPiBGcm9tOiBWaW5jZW50IENFU1NPTiBbbWFpbHRvOnZpbmNlbnQuY2Vz
c29uQHNtaWxlLmZyXQ0KPiBTZW50OiBNb25kYXksIEp1bmUgMTMsIDIwMTYgNzowOSBQTQ0KPiBU
bzogQW1pdGt1bWFyIEthcndhcg0KPiBDYzogUmF5bW9uZCBIYXllczsgbGludXgtd2lyZWxlc3NA
dmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJFOiBtd2lmaWV4K3dwYV9zdXBwbGljYW50IGNh
bm5vdCBzZXQgdXAgV1BBL1dQQTIgQURIT0MNCj4gDQo+IEFib3V0IHRoZSBzdHJhbmdlIGJlaGF2
aW91ciB3aXRoIHRoZSB0d28gZGV2aWNlcyBjb25uZWN0aW5nIGRlc3BpdGUgdGhlDQo+IGJhZCBw
YXNzd29yZHMsIEkgbWFkZSBhIGxpdHRsZSBtaXN0YWtlOiBvbiB0aGUgZGV2aWNlIDIsIHdwYV9z
dXBwbGljYW50DQo+IHdhcyBub3QgYnVpbHQgd2l0aCBvcHRpb24gQ09ORklHX0lCU1NfUlNOPXku
IEJ1dCBzdGlsbCwgZGV2aWNlIDEgc2hvdWxkDQo+IG5vdCBhY2NlcHQgZGV2aWNlIDIuLi4NCj4g
DQo+IE5vdGUgdGhhdCB3aXRoIG9wdGlvbiBDT05GSUdfSUJTU19SU049eSBlbmFibGVkIG9uIGJv
dGggZGV2aWNlcywgV1BBLVBTSw0KPiBjb25uZWN0aW9uIGRvZXMgbm90IHdvcmssIGV2ZW4gd2l0
aCB0aGUgcmlnaHQgcGFzc3dvcmQuLi4NCj4gDQoNCkkgc2VlLiBQbGVhc2Ugc2hhcmUgdGhlIHdw
YV9zdXBwbGljYW50IGxvZ3Mgd2l0aCBDT05GSUdfSUJTU19SU049eSBlbmFibGVkIGZvciBhbmFs
eXNpcy4NCg0KUmVnYXJkcywNCkFtaXRrdW1hcg0K
