Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:46448 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756358Ab3ANSrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 13:47:21 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Tim Shepard <shep@laptop.org>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Mon, 14 Jan 2013 10:40:27 -0800
Subject: RE: [PATCH] mwifiex: change is_suspended variable type to atomic_t
Message-ID: <477F20668A386D41ADCC57781B1F70430D13FDC35F@SC-VEXCH1.marvell.com> (sfid-20130114_194729_798908_AB851C17)
References: <1357880244-14610-1-git-send-email-bzhao@marvell.com>
	 (sfid-20130111_060013_448876_78450B81)
 <1357901563.9767.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1357901563.9767.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gPiBpc19zdXNwZW5kZWQgZmxhZyBjYW4gYmUgYWNjZXNzZWQgYnkg
bXVsdGlwbGUgdGhyZWFkcy4NCj4gPiBVc2UgYXRvbWljIHZhcmlhYmxlIHR5cGUgZm9yIGlzX3N1
c3BlbmRlZCB0byBlbnN1cmUgdGhhdCB0aGVyZQ0KPiA+IGFyZSBubyB1bmRlZmluZWQgYmVoYXZp
b3Vycy4NCj4gDQo+IGF0b21pY190IGRvZXNuJ3QgZG8gd2hhdCB5b3Ugc2VlbSB0byB0aGluayBp
dCBkb2VzLCB0aGlzIHBhdGNoIGlzDQo+IGNvbXBsZXRlbHkgYm9ndXMuDQo+IA0KDQpUaGFuayB5
b3UgZm9yIHlvdXIgY29tbWVudC4gUGVyaGFwcyB3ZSBuZWVkIHNwaW5sb2NrcyBoZXJlIHRvIHBy
ZXZlbnQgdGhlIHBvc3NpYmxlIHJhY2VzLg0KDQpIaSBKb2huLCBwbGVhc2UgZHJvcCB0aGlzIHBh
dGNoLg0KDQpUaGFua3MsDQpCaW5nDQoNCg0KDQoNCg==
