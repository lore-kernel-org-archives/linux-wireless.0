Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:9639 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751527AbdHNUNf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 16:13:35 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "igor.mitsyanko.os@quantenna.com" <igor.mitsyanko.os@quantenna.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "avinashp@quantenna.com" <avinashp@quantenna.com>,
        "sergey.matyukevich.os@quantenna.com"
        <sergey.matyukevich.os@quantenna.com>
Subject: Re: [PATCH] nl80211: add an option to allow MFP without requiring it
Date: Mon, 14 Aug 2017 20:13:18 +0000
Message-ID: <1502741597.8162.1.camel@intel.com> (sfid-20170814_221339_538858_F1657FBC)
References: <20170814134911.20869-1-emmanuel.grumbach@intel.com>
         <a35aea64-b391-2719-c8cb-92ef9c9288c7@broadcom.com>
         <1723b617-2272-330e-958c-bb988aa504d5@quantenna.com>
In-Reply-To: <1723b617-2272-330e-958c-bb988aa504d5@quantenna.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uLCAyMDE3LTA4LTE0IGF0IDEzOjA4IC0wNzAwLCBJZ29yIE1pdHN5YW5rbyB3cm90ZToN
Cj4gT24gMDgvMTQvMjAxNyAxMjoyMiBQTSwgQXJlbmQgdmFuIFNwcmllbCB3cm90ZToNCj4gPiBP
biAxNC0wOC0xNyAxNTo0OSwgRW1tYW51ZWwgR3J1bWJhY2ggd3JvdGU6DQo+ID4gPiBVc2VyIHNw
YWNlIGNhbiBub3cgYWxsb3cgdGhlIGtlcm5lbCB0byBhc3NvY2lhdGUgdG8gYW4gQVANCj4gPiA+
IHRoYXQgcmVxdWlyZXMgTUZQIG9yIHRoYXQgZG9lc24ndCBoYXZlIE1GUCBlbmFibGVkIGluIHRo
ZQ0KPiA+ID4gc2FtZSBOTDgwMjExX0NNRF9DT05ORUNUIGNvbW1hbmQuDQo+ID4gPiBUaGUgZHJp
dmVyIC8gZmlybXdhcmUgd2lsbCBkZWNpZGUgd2hldGhlciB0byB1c2UgaXQgb3Igbm90Lg0KPiA+
ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBFbW1hbnVlbCBHcnVtYmFjaCA8ZW1tYW51ZWwuZ3J1
bWJhY2hAaW50ZWwuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiBBIHNob3J0IHRvdXIgb2YgdGhlIGRy
aXZlcnMgdGF1Z2h0IG1lIHRoYXQgb25seSBRdWFudGVubmEgcmVhbGx5DQo+ID4gPiBsb29rDQo+
ID4gPiBhdCBjZmc4MDIxMV9jb25uZWN0X3BhcmFtczo6c21lIHdoaWNoIGNhbiBub3cgYmUgMi4g
VGhpcyBpcyB3aHkNCj4gPiA+IHRoZSBtYWludGFpbmVyIG9mIHRoaXMgZHJpdmVyIGlzIENDZWQu
DQo+ID4gDQo+ID4gSW5kZWVkIGluIGJyY21mbWFjIHRoZSBJRSBpcyBwcm9jZXNzZWQgdG8gZGV0
ZXJtaW5lIHdoZXRoZXIgaXQgaXMNCj4gPiByZXF1aXJlZCBvciBvcHRpb25hbC4gUHJvYmFibHkg
d2lsbCBjaGFuZ2Ugb3VyIGRyaXZlciB0byB1c2UgdGhlDQo+ID4gZXhwbGljaXQgbWZwIHZhbHVl
cyBmcm9tIGNmZzgwMjExX2Nvbm5lY3RfcGFyYW1zOjpzbWUuDQo+IA0KPiBNYXliZSB0aGlzIGlz
IGEgcmlnaHQgd2F5IHRvIGRvIHRoYXQsIGF2b2lkaW5nIHRoYXQgY29tcGF0aWJpbGl0ecKgDQo+
IHByb2JsZW0gKG5vIG5ldyBOTCogZmxhZ3MpPyBFeGNlcHQgZm9yIG1heWJlIG5sODAyMTEgbGF5
ZXIgc2hvdWxkDQo+IHBhcnNlwqANCj4gaXQgaW5zdGVhZCwgbm90IGRyaXZlci4NCg0KU2VlbXMg
b2RkIHRvIG1lLCBzaW5jZSB0aGVyZSBhbHJlYWR5IGlzIGFuIE5MIGF0dHJpYnV0ZSBmb3IgdGhp
cyBhbmQNCnlvdSB3YW50IHRoZSB1c2VyIHNwYWNlIHRvIGRlY2lkZSBvbiB0aGUgcG9saWN5IEkg
dGhpbmsuDQoNCj4gDQo+IEl0IGlzIGtpbmQgb2Ygbm90IGNsZWFyIHJpZ2h0IG5vdyBmb3IgZHJp
dmVycyB3aGVyZSB0byBnZXQNCj4gaW5mb3JtYXRpb24gZnJvbToNCj4gLSBOTCBhdHRyaWJ1dGVz
IHBhc3NlZCBmcm9tIHVzZXJzcGFjZSBhbmQgZm9yd2FyZGVkIHRvIGEgZHJpdmVyDQoNClNpbmNl
IHRob3NlIGV4aXN0LCBpdCBzZWVtcyB0byBtYWtlIG1vcmUgc2Vuc2UgdG8gbWUgdG8gdXNlIHRo
b3NlDQpyYXRoZXIgdGhhbiBhbnkgaW4tZHJpdmVyIGRlY2lkZWQgcG9saWN5LiBVc3VhbGx5LCBk
ZWNpZGluZyB1cG9uDQpwb2xpY2llcyBmcm9tIGxvd2VyIGxldmVscyBpcyBmcm93bmVkIHVwb24g
SSdkIHNheS4NCg0KPiAtIElFcyBwYXNzZWQgZnJvbSB1c2Vyc3BhY2UsIHBhcnNlZCBieSBubDgw
MjExIGFuZCBmb3J3YXJkZWQgdG8gYQ0KPiBkcml2ZXINCj4gLSBJRXMgdGhhdCBhcmUgcGFzc2Vk
IGZyb20gdXNlcnNwYWNlIGFuZCBwYXJzZWQgYnkgZHJpdmVycyBkaXJlY3RseQ0KPiANCj4gPiAN
Cj4gPiBUaGFua3MsDQo+ID4gQXJlbmQNCj4gDQo+IA==
