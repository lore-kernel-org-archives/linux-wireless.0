Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18808 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbaKLOdU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 09:33:20 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Michal Kazior <michal.kazior@tieto.com>,
	David Ward <david.ward@ll.mit.edu>
CC: "Berg, Johannes" <johannes.berg@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Martin Hundeb?ll <martin@hundeboll.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] iwlwifi: dvm: Implement sta_rc_update() mac80211
 callback
Date: Wed, 12 Nov 2014 14:31:48 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B562EC4@hasmsx107.ger.corp.intel.com> (sfid-20141112_153341_155288_3CA17702)
References: <1411997268.1663.0@smtp.hundeboll.net>
	<1415773612-8724-1-git-send-email-david.ward@ll.mit.edu>
 <CA+BoTQkU0Ldd+Ui-EW26DuAFiRQEeV08k8grV_N79j6zLkHbsw@mail.gmail.com>
In-Reply-To: <CA+BoTQkU0Ldd+Ui-EW26DuAFiRQEeV08k8grV_N79j6zLkHbsw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBPbiAxMiBOb3ZlbWJlciAyMDE0IDA3OjI2LCBEYXZpZCBXYXJkIDxkYXZpZC53YXJkQGxsLm1p
dC5lZHU+IHdyb3RlOg0KPiBbLi4uXQ0KPiA+ICtzdGF0aWMgdm9pZCBpd2xhZ25fbWFjX3N0YV9y
Y191cGRhdGUoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsDQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBpZWVlODAyMTFfc3RhICpzdGEs
IHUzMg0KPiA+ICtjaGFuZ2VkKSB7DQo+ID4gKyAgICAgICBzdHJ1Y3QgaXdsX3ByaXYgKnByaXYg
PSBJV0xfTUFDODAyMTFfR0VUX0RWTShodyk7DQo+ID4gKw0KPiA+ICsgICAgICAgaWYgKCEoY2hh
bmdlZCAmIElFRUU4MDIxMV9SQ19TVVBQX1JBVEVTX0NIQU5HRUQpKQ0KPiA+ICsgICAgICAgICAg
ICAgICByZXR1cm47DQo+ID4gKw0KPiA+ICsgICAgICAgLyogVXBkYXRlIHJhdGUgc2NhbGluZyAq
Lw0KPiA+ICsgICAgICAgSVdMX0RFQlVHX0lORk8ocHJpdiwNCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICJVcGRhdGluZyByYXRlIHNjYWxpbmcgZm9yIHN0YXRpb24gJXBNXG4iLA0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgc3RhLT5hZGRyKTsNCj4gPiArICAgICAgIGl3bF9yc19yYXRl
X2luaXQocHJpdiwgc3RhLCBpd2xfc3RhX2lkKHN0YSkpOw0KPiANCj4gc3RhX3JjX3VwZGF0ZSgp
IG11c3QgYmUgYXRvbWljLiBJJ20gbm90IHJlYWxseSBmYW1pbGlhciB3aXRoIGl3bCB0aGF0IG11
Y2ggYnV0DQo+IGl0IHNlZW1zIHRvIG1lIGl3bF9yc19yYXRlX2luaXQoKSAtPiBpd2xfc2VuZF9s
cV9jbWQoLi4uLCAwLA0KPiB0cnVlKSBjYW4gc2xlZXAsIG5vPw0KPiANCj4gDQpZZXMgLSBnb29k
IHBvaW50Lg0K
