Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46475 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbbEDHCO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 03:02:14 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "jkosina@suse.cz" <jkosina@suse.cz>
CC: "piotr.karbowski@gmail.com" <piotr.karbowski@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi getting stuck with current Linus' tree (646da63172)
Date: Mon, 4 May 2015 07:02:07 +0000
Message-ID: <1430722924.26162.4.camel@intel.com> (sfid-20150504_090220_461790_F11CC64C)
References: <alpine.LNX.2.00.1504222235340.3695@pobox.suse.cz>
	   <1429764440.4084.5.camel@intel.com>
	   <alpine.LNX.2.00.1504231011500.3695@pobox.suse.cz>
	   <1429780366.11859.1.camel@intel.com>
	   <alpine.LNX.2.00.1504231114290.3695@pobox.suse.cz>
	   <CA+uBNfxXoLj9Nfss+j1G3PY9A2t=N6KRiYUAdoxiUOZvigwyAw@mail.gmail.com>
	  <1429812611.23202.4.camel@intel.com>
	  <alpine.LNX.2.00.1505032340090.17496@pobox.suse.cz>
	 <1430713926.3388.1.camel@intel.com>
	 <alpine.LNX.2.00.1505040853590.17496@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1505040853590.17496@pobox.suse.cz>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uLCAyMDE1LTA1LTA0IGF0IDA4OjU1ICswMjAwLCBKaXJpIEtvc2luYSB3cm90ZToNCj4g
T24gTW9uLCA0IE1heSAyMDE1LCBHcnVtYmFjaCwgRW1tYW51ZWwgd3JvdGU6DQo+IA0KPiA+ID4g
c28gb3ZlciBhIHBhc3QgZmV3IGRheXMsIEkgdHJpZWQgdG8gcGVyZm9ybSBhIGJpc2VjdCwgYnV0
IGZhaWxlZCBhcyANCj4gPiA+IGV4cGVjdGVkLiBUaGUgaXNzdWUgaXMgbm90IHJlbGlhYmx5IGVu
b3VnaCByZXByb2R1Y2libGUgZm9yIG1lLCBzbyBJIGVuZGVkIA0KPiA+ID4gdXAgd2l0aCBhIGNv
bXBsZXRlbHkgYm9ndXMgY29tbWl0Lg0KPiA+ID4gDQo+ID4gPiAqSG93ZXZlciosIG5vdyB0aGF0
IEkgaGF2ZSBiZWVuIGZvbGxvd2luZyB0aGUgY2F1c2VzIGFuZCBzeW1wdG9tcyBtb3JlIA0KPiA+
ID4gY2xvc2VseSAoZHVlIHRvIHRoZSBiaXNlY3QgYXR0ZW1wdCksIEkgaGF2ZSB0byBjb25maXJt
IHRoYXQgdGhlIGlzc3VlIA0KPiA+ID4gaGFwcGVucyBtdWNoIG1vcmUgb2Z0ZW4gd2hlbiB0aGUg
bWFjaGluZSBpcyBxdWVzdGlvbiBpcyBwaHlzaWNhbGx5IGJlaW5nIA0KPiA+ID4gbW92ZWQgd2hl
biBhc3NvY2lhdGVkLg0KPiA+ID4gDQo+ID4gDQo+ID4gSSBhbSBkb2luZyB0aGlzIGFsbCB0aGUg
dGltZSBhbmQgSSBkb24ndCBoaXQgeW91ciBwcm9ibGVtLiBXaXRob3V0IGFueQ0KPiA+IGxvZ3Mg
SSBkb24ndCBzZWUgaG93IEkgY2FuIGhlbHAgaGVyZS4gUGxlYXNlIHRyeSB0byBjYXRjaCBsb2dz
IG9mIHRoZQ0KPiA+IGNyYXNoLiBUaGFua3MuDQo+IA0KPiBJIGhhdmUgcHJvdmlkZWQgdGhlbSBp
biB0aGUgdmVyeSBmaXJzdCBlLW1haWwgdG8gdGhpcyB0aHJlYWQ7IHNlZQ0KPiANCj4gCWh0dHBz
Oi8vbGttbC5vcmcvbGttbC8yMDE1LzQvMjIvNjAxDQo+IA0KPiBJZiB0aGVyZSBpcyBhbnkgd2F5
IGhvdyB0byBvYnRhaW4gbW9yZSB2ZXJib3NlIC8gdXNlZnVsIGxvZ3MsIHBsZWFzZSBsZXQgDQo+
IG1lIGtub3csIEknbGwgYmUgaGFwcHkgdG8gZG8gdGhhdC4NCj4gDQoNCg0KU29ycnksIG15IGJh
ZC4gSSBsb3N0IGNvbnRleHQgaGVyZS4uLiBTbyBJIHJlYWxseSBkb24ndCBrbm93IHdoYXQgdG8N
CnNheS4gSSBjYW4ndCBzZWUgYW55IGl3bHdpZmkgY29tbWl0IHRoYXQgY291bGQgYmUgY2F1c2lu
ZyB0aGlzLCBPVE9ILA0KYmlzZWN0aW9uIGRpZG4ndCBicmluZyBhbnkgcmVzdWx0cy4gWW91IGNh
biB0cnkgdG8gdW5yZWdpc3RlciB0aGUgZGV2aWNlDQpmcm9tIFBDSSBhbmQgdGhlbiB0byByZXNj
YW4uIEl0IHdvcmtlZCBmb3Igc29tZSBwZW9wbGUuIE90aGVyIHRoYW4gdGhhdCwNCkkgY2FuJ3Qg
ZG8gbXVjaC4gRGlkIHlvdSB1cGRhdGUgeW91ciBCSU9TIGJlZm9yZSB5b3Ugc3RhcnRlZCB0byBz
ZWUgdGhpcw0KZmFpbHVyZT8NCg==
