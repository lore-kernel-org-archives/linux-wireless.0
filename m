Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39449 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbcCJG11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 01:27:27 -0500
From: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Allow probe response frame rx to user space in
 AP mode
Date: Thu, 10 Mar 2016 06:27:00 +0000
Message-ID: <56E113AE.8050300@qti.qualcomm.com> (sfid-20160310_072731_013223_82A3F308)
References: <1457334731-6456-1-git-send-email-vthiagar@qti.qualcomm.com>
	 <1457456123.24270.11.camel@sipsolutions.net>
	 <56DFB02A.5070207@qti.qualcomm.com>
 <1457515749.2042.0.camel@sipsolutions.net>
In-Reply-To: <1457515749.2042.0.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gV2VkbmVzZGF5IDA5IE1hcmNoIDIwMTYgMDI6NTkgUE0sIEpvaGFubmVzIEJlcmcgd3JvdGU6
DQo+IE9uIFdlZCwgMjAxNi0wMy0wOSBhdCAwNToxMCArMDAwMCwgVGhpYWdhcmFqYW4sIFZhc2Fu
dGhha3VtYXIgd3JvdGU6DQo+DQo+PiBXaGVuIGFuIHVzZXIgc3BhY2Ugd2FudHMgdG8gaGF2ZSBj
b250cm9sIG92ZXIgdGhlIGR1cmF0aW9uIG9mIG9mZi0NCj4+IGNoYW5uZWwgKHNpbmdsZSBjaGFu
bmVsKSBzY2FuIGl0IGNvdWxkIHVzZSByZW1haW4tb24tY2hhbm5lbA0KPj4gaW50ZXJmYWNlIGlu
c3RlYWQgb2YgdHJpZ2dlcl9zY2FuIHRvIHBlcmZvcm0gb2ZmLWNoYW5uZWwgc2Nhbi4gSSBkb250
DQo+PiB0aGluayBCU1MgY2FjaGUgd2lsbCBiZSB1cGRhdGVkIHdpdGggdGhlIEJTUyBpbmZvcm1h
dGlvbiByZWNlaXZlZA0KPj4gZHVyaW5nIHJlbWFpbi1vbi1jaGFubmVsLiBJbiB0aGlzIGNhc2Us
IHVzZXIgc3BhY2UgY291bGQgdXNlIHByb2JlDQo+PiByZXNwb25zZSBmcmFtZXMgdG8gYnVpbGQg
QlNTIGxpc3QuDQo+Pg0KPiBUaGF0J3Mgbm90IGEgdXNlIGNhc2UsIHRoYXQncyBhbiBpbXBsZW1l
bnRhdGlvbj8NCg0KVXNlciBzcGFjZSB3YW50cyB0byBidWlsZCB1cCBhIGxpc3Qgb2YgcHJlZmVy
cmVkIEJTUyBhbmQgY2hhbm5lbCBmcm9tIG9mZi1jaGFubmVsDQpzY2FuIGFuZCB0aGVzZSBpbmZv
cm1hdGlvbiBjYW4gYmUgc2hhcmVkIHdpdGggb3RoZXIgc3RhdGlvbnMgYXJvdW5kIHRvIGJldHRl
cg0KdXNlIHRoZSBzcGVjdHJ1bS4gV2hlbiB0aGUgYnNzIGxpc3QgaXMgbm90IGF2YWlsYWJsZSBk
dXJpbmcgcmVtYWluLW9uIGNoYW5uZWwsDQpwcm9iZSByZXNwb25zZSB3aWxsIGJlIHVzZWQgdG8g
cHJlcGFyZSB0aGUgbGlzdC4NCg0KPg0KPiBGV0lXLCB3ZSBoYXZlIHBhdGNoZXMgcGVuZGluZyB0
byBhZGQgc29tZSBkd2VsbCB0aW1lIGNvbnRyb2wgZm9yDQo+IHNjYW5uaW5nIHNpbmNlIGl0J3Mg
cmVxdWlyZWQgZm9yIHNvbWUgcmFkaW8gcmVzb3VyY2UgbWVhc3VyZW1lbnQNCj4gdGhpbmdzLiBJ
dCBzZWVtcyBsaWtlIHRoYXQgd291bGQgYWRkcmVzcyB5b3VyIHVzZSBjYXNlLg0KDQpTdXJlLCB0
aGlzIHdpbGwgd29yayBmb3IgbWUuIFRoYW5rcw0KDQpWYXNhbnRo
