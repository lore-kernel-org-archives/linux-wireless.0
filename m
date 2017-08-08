Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22960 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751464AbdHHIVR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 04:21:17 -0400
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: linuxwifi <linuxwifi@intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "jprvita@gmail.com" <jprvita@gmail.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jprvita@endlessm.com" <jprvita@endlessm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] iwlwifi: Demote messages about fw flags size to info
Date: Tue, 8 Aug 2017 08:21:09 +0000
Message-ID: <1502180468.15969.140.camel@intel.com> (sfid-20170808_102137_096084_1FBD3B13)
References: <063D6719AE5E284EB5DD2968C1650D6DD004A3CC@AcuExch.aculab.com>
         <20170803144728.32305-1-jprvita@endlessm.com>
In-Reply-To: <20170803144728.32305-1-jprvita@endlessm.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1LCAyMDE3LTA4LTAzIGF0IDA3OjQ3IC0wNzAwLCBKb8OjbyBQYXVsbyBSZWNoaSBWaXRh
IHdyb3RlOg0KPiBUaGVzZSBtZXNzYWdlcyBhcmUgbm90IHJlcG9ydGluZyBhIHJlYWwgZXJyb3Is
IGp1c3QgdGhlIGZhY3QgdGhhdCB0aGUNCj4gZmlybXdhcmUga25vd3MgYWJvdXQgbW9yZSBmbGFn
cyB0aGFuIHRoZSBkcml2ZXIuDQo+IA0KPiBDdXJyZW50bHkgdGhlc2UgbWVzc2FnZXMgYXJlIHBy
ZXNlbnRlZCB0byB0aGUgdXNlciBkdXJpbmcgYm9vdCBpZiB0aGVyZQ0KPiBpcyBubyBib290c3Bs
YXNoIGNvdmVyaW5nIHRoZSBjb25zb2xlLCBldmVuIHdoZW4gYm9vdGluZyB0aGUga2VybmVsIHdp
dGgNCj4gInF1aWV0Ii4NCj4gDQo+IERlbW90aW5nIGl0IHRvIHRoZSB3YXJuIGxldmVsIGhlbHBz
IGhhdmluZyBhIGNsZWFuIGJvb3QgcHJvY2Vzcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEpvw6Nv
IFBhdWxvIFJlY2hpIFZpdGEgPGpwcnZpdGFAZW5kbGVzc20uY29tPg0KPiAtLS0NCj4gDQo+IHYy
IGNoYW5nZXM6DQo+ICAtIFNldCB0byB3YXJuIGxldmVsIGluc3RlYWQgb2YgaW5mbw0KPiANCj4g
djMgY2hhbmdlczoNCj4gIC0gRml4IGNvbW1pdCBtZXNzYWdlIHR5cG8NCg0KVGhhbmtzLCBKb8Oj
byBQYXVsbyEgSSBwdXNoZWQgdGhpcyB0byBvdXIgaW50ZXJuYWwgdHJlZSBhbmQgaXQgd2lsbA0K
ZXZlbnR1YWxseSByZWFjaCB0aGUgbWFpbmxpbmUgZm9sbG93aW5nIG91ciBub3JtYWwgdXBzdHJl
YW1pbmcgcHJvY2Vzcy4NCg0KLS0NCkNoZWVycywNCkx1Y2Eu
