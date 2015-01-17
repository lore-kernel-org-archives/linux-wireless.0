Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43819 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752229AbbAQNGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2015 08:06:53 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: Avinash Patil <patila@marvell.com>, Cathy Luo <cluo@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 17 Jan 2015 05:05:25 -0800
Subject: RE: [PATCH] mwifiex: check driver status in connect and scan
 handlers
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951B1633A3FA@SC-VEXCH1.marvell.com> (sfid-20150117_140744_094654_F8E7303B)
References: <1420631859-29004-1-git-send-email-akarwar@marvell.com>
 <CAEhWJFnr28=Q4TFwzwcNoWPQRbUY0+mWu8nbocs3789v8X1PHw@mail.gmail.com>
In-Reply-To: <CAEhWJFnr28=Q4TFwzwcNoWPQRbUY0+mWu8nbocs3789v8X1PHw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgS2FsbGUsDQoNCj5PbiBXZWQsIEphbiA3LCAyMDE1IGF0IDU6MjcgUE0sIEFtaXRrdW1hciBL
YXJ3YXIgPGFrYXJ3YXJAbWFydmVsbC5jb20+IHdyb3RlOg0KPklnbm9yZSBzY2FuIGFuZCBjb25u
ZWN0aW9uIHJlcXVlc3RzIGZyb20gY2ZnODAyMTEgd2hlbiBkcml2ZXINCj51bmxvYWQgaXMgaW4g
cHJvY2VzcyBvciBwcmV2aW91cyBjb21tYW5kIGhhcyB0aW1lZCBvdXQgZHVlIHRvDQo+YSBmaXJt
d2FyZSBidWcuIFRoaXMgcGF0Y2ggZml4ZXMgY29ybmVyIGNhc2Ugc3lzdGVtIGNyYXNoDQo+aXNz
dWVzLg0KDQo+U2lnbmVkLW9mZi1ieTogQW1pdGt1bWFyIEthcndhciA8YWthcndhckBtYXJ2ZWxs
LmNvbT4NCj5TaWduZWQtb2ZmLWJ5OiBDYXRoeSBMdW8gPGNsdW9AbWFydmVsbC5jb20+DQo+LS0t
DQo+wqBkcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L2NmZzgwMjExLmMgfCA4ICsrKysrKysr
DQo+wqBkcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L3NjYW4uY8KgIMKgIMKgfCA2ICsrKysr
Kw0KPsKgMiBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspDQoNCkNvdWxkIHlvdSBwbGVh
c2UgY2hlY2sgdGhpcyBwYXRjaD8gTGV0IG1lIGtub3cgaWYgeW91IHdhbnQgbWUgdG8gcmVzZW5k
IGl0Lg0KDQpCZXN0IHJlZ2FyZHMsDQpBbWl0DQo=
