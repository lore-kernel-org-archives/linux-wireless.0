Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38849 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751218AbcITN43 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 09:56:29 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Subject: RE: [PATCH 2/2] mwifiex: parse WMM IEs from hostapd for mwifiex AP
Date: Tue, 20 Sep 2016 13:56:17 +0000
Message-ID: <49139f0275e442c799767018906eab6d@SC-EXCH04.marvell.com> (sfid-20160920_155634_229299_A23AA8CB)
References: <1357174561-28898-1-git-send-email-bzhao@marvell.com>
         <1357174561-28898-2-git-send-email-bzhao@marvell.com>
         (sfid-20130103_015637_973661_B4551387)
 <1473846871.4423.14.camel@sipsolutions.net>
In-Reply-To: <1473846871.4423.14.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gRnJvbTogSm9oYW5uZXMgQmVyZyBbbWFpbHRvOmpvaGFubmVzQHNp
cHNvbHV0aW9ucy5uZXRdDQo+IFNlbnQ6IFdlZG5lc2RheSwgU2VwdGVtYmVyIDE0LCAyMDE2IDM6
MjUgUE0NCj4gVG86IEJpbmcgWmhhbzsgbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnDQo+
IENjOiBKb2huIFcuIExpbnZpbGxlOyBBbWl0a3VtYXIgS2Fyd2FyOyBBdmluYXNoIFBhdGlsOyBO
aXNoYW50DQo+IFNhcm11a2FkYW07IEZyYW5rIEh1YW5nDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
Mi8yXSBtd2lmaWV4OiBwYXJzZSBXTU0gSUVzIGZyb20gaG9zdGFwZCBmb3IgbXdpZmlleA0KPiBB
UA0KPiANCj4gT2J2aW91c2x5IHRoaXMgaXMgYSB2ZXJ5IG9sZCBwYXRjaCwgYnV0IEkgd2FzIGp1
c3QgbG9va2luZyBhdCB1c2VycyBvZg0KPiBjZmc4MDIxMV9maW5kX3ZlbmRvcl9pZSgpIGFuZCBy
ZWFsaXplZCB5b3UgaGF2ZSBhIGJ1ZyBoZXJlOg0KPiANCj4gPiArCXZlbmRvcl9pZSA9IGNmZzgw
MjExX2ZpbmRfdmVuZG9yX2llKFdMQU5fT1VJX01JQ1JPU09GVCwNCj4gPiArCQkJCQnCoMKgwqDC
oFdMQU5fT1VJX1RZUEVfTUlDUk9TT0ZUXw0KPiA+IFdNTSwNCj4gPiArCQkJCQnCoMKgwqDCoHBh
cmFtcy0+YmVhY29uLnRhaWwsDQo+ID4gKwkJCQkJwqDCoMKgwqBwYXJhbXMtDQo+ID4gPmJlYWNv
bi50YWlsX2xlbik7DQo+ID4gKwlpZiAodmVuZG9yX2llKSB7DQo+ID4gKwkJd21tX2llID0gKHN0
cnVjdCBpZWVlX3R5cGVzX2hlYWRlciAqKXZlbmRvcl9pZTsNCj4gPiArCQltZW1jcHkoJmJzc19j
ZmctPndtbV9pbmZvLCB3bW1faWUgKyAxLA0KPiA+ICsJCcKgwqDCoMKgwqDCoMKgc2l6ZW9mKGJz
c19jZmctPndtbV9pbmZvKSk7DQo+ID4gKwkJcHJpdi0+d21tX2VuYWJsZWQgPSAxOw0KPiANCj4g
WW91IG5lZWQgdG8gY2hlY2sgdGhhdCB0aGUgdmVuZG9yX2llIGlzIGFjdHVhbGx5IGxvbmcgZW5v
dWdoLg0KPiANCg0KU3VyZS4gSSB3aWxsIHByZXBhcmUgYSBwYXRjaCB0byBhZGRyZXNzIHRoaXMu
IA0KDQpSZWdhcmRzLA0KQW1pdGt1bWFyIEthcndhcg0K
