Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55361 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752008AbcIOJSR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 05:18:17 -0400
From: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>,
        "Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>
Subject: RE: [PATCH v5] cfg80211: Add support to configure a beacon data rate
Date: Thu, 15 Sep 2016 09:18:09 +0000
Message-ID: <5986e153aa334a95ac18f2682211dfa1@aphydexm01f.ap.qualcomm.com> (sfid-20160915_111821_572250_9A6B1E2C)
References: <1473854924-10352-1-git-send-email-pkushwah@qti.qualcomm.com>
         <1473927421.4423.38.camel@sipsolutions.net>
         (sfid-20160915_101917_590850_04C3DE8A)
 <1473929362.25838.0.camel@sipsolutions.net>
         <0b1aa5b1fc484bb481ff5be8e187acc2@aphydexm01f.ap.qualcomm.com>
 <1473930264.25838.2.camel@sipsolutions.net>
In-Reply-To: <1473930264.25838.2.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBJJ20gZXZlbiB3aWxsaW5nIHRvIGFkZCBpdCBteXNlbGYgLSBzaG91bGQgd2UganVzdCBoYXZl
IHRocmVlIGZlYXR1cmUgZmxhZ3M/DQpJIGd1ZXNzICwgWWVzLg0KDQpSZWdhcmRzLA0KU3VuaWwN
Cg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEpvaGFubmVzIEJlcmcgW21haWx0
bzpqb2hhbm5lc0BzaXBzb2x1dGlvbnMubmV0XSANClNlbnQ6IFRodXJzZGF5LCBTZXB0ZW1iZXIg
MTUsIDIwMTYgMjozNCBQTQ0KVG86IFVuZGVrYXJpLCBTdW5pbCBEdXR0IDx1c2R1dHRAcXRpLnF1
YWxjb21tLmNvbT47IEt1c2h3YWhhLCBQdXJ1c2hvdHRhbSA8cGt1c2h3YWhAcXRpLnF1YWxjb21t
LmNvbT4NCkNjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IE1hbGluZW4sIEpvdW5p
IDxqb3VuaUBxY2EucXVhbGNvbW0uY29tPjsgSHVsbHVyIFN1YnJhbWFueWFtLCBBbWFybmF0aCA8
YW1hcm5hdGhAcWNhLnF1YWxjb21tLmNvbT4NClN1YmplY3Q6IFJlOiBbUEFUQ0ggdjVdIGNmZzgw
MjExOiBBZGQgc3VwcG9ydCB0byBjb25maWd1cmUgYSBiZWFjb24gZGF0YSByYXRlDQoNCk9uIFRo
dSwgMjAxNi0wOS0xNSBhdCAwOTowMCArMDAwMCwgVW5kZWthcmksIFN1bmlsIER1dHQgd3JvdGU6
DQo+ID4gDQo+ID4gc2hvdWxkbid0IHdlIGhhdmUgc29tZSBmZWF0dXJlIGZsYWdzIGhlcmUgdG8g
aW5kaWNhdGUgdGhhdCB0aGUgDQo+ID4gZHJpdmVyIGFjdHVhbGx5IHN1cHBvcnRzIHRoaXM/DQo+
IFllcy4gQ2FuIHlvdSBwbGVhc2UgYWNjZXB0IHRoaXMgd2l0aCBhIG5ldyBjb21taXQuDQo+IA0K
SSdtIGV2ZW4gd2lsbGluZyB0byBhZGQgaXQgbXlzZWxmIC0gc2hvdWxkIHdlIGp1c3QgaGF2ZSB0
aHJlZSBmZWF0dXJlIGZsYWdzPw0KDQpBUF9CRUFDT05fUkFURV9MRUdBQ1kNCkFQX0JFQUNPTl9S
QVRFX0hUDQpBUF9CRUFDT05fUkFURV9WSFQNCg0KPw0KDQpqb2hhbm5lcw0K
