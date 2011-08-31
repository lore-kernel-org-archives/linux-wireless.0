Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3046 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab1HaO4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 10:56:37 -0400
From: "Sumangala, Suraj" <surajs@qca.qualcomm.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	"Balasubramanian, senthilkumar" <senthilb@qca.qualcomm.com>,
	"Mehta, Vipin" <vipimeht@qca.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC] nl80211: Added NL80211 commands for Bluetooth-WiFi coex
Date: Wed, 31 Aug 2011 14:56:34 +0000
Message-ID: <480687D4EEFE7447A2E09AADFF6673621AF7DF82@nasanexd02a.na.qualcomm.com> (sfid-20110831_165641_281847_162A2631)
References: <1314771915-8848-1-git-send-email-surajs@qca.qualcomm.com>
	 (sfid-20110831_082525_612687_34CC3735),<1314772217.4161.10.camel@jlt3.sipsolutions.net>
	 <480687D4EEFE7447A2E09AADFF6673621AF7CDCF@nasanexd02a.na.qualcomm.com>
	,<1314772832.4161.16.camel@jlt3.sipsolutions.net>
	 <480687D4EEFE7447A2E09AADFF6673621AF7CE0B@nasanexd02a.na.qualcomm.com>
 <1314801657.3373.260.camel@aeonflux>
In-Reply-To: <1314801657.3373.260.camel@aeonflux>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgTWFyY2VsLA0KDQoNCj4gdGhpcyBsb29rcyBsaWtlIHRoZSB0b3RhbCB3cm9uZyBhcHByb2Fj
aCB0byBtZS4gVGhpcyBuZWVkcyB0byBiZSBkb25lIGJldHdlZW4gbWFjODAyMTEgYW5kIEJsdWV0
b290aCBzdWJzeXN0ZW1zIGluIHRoZSBrZXJuZWwgZGlyZWN0bHkuIEdvaW5nIHRocm91Z2ggdXNl
cnNwYWNlIGZvciB0aGlzIGlzIGEgcHJldHR5IGJhZCBpZGVhLg0KDQo+IEVzcGVjaWFsbHkgaWYg
eW91IHdhbm5hIGxpc3RlbiBvbiBELUJ1cyBldmVudHMgZnJvbSBibHVldG9vdGhkIGFuZCB0aGVu
IHJ1biBhbm90aGVyIHByb2Nlc3MgdG8gdGhlbiBleGVjdXRlIG5sODAyMTEgY29tbWFuZHMgbG9v
a3MgbGlrZSB0b3RhbCBvdmVyaGVhZCBhdCBubyBnYWluLiBOb3QgdG8gdGFsayBhYm91dCBwb3Rl
bnRpYWwgbGF0ZW5jeSA+IGVmZmVjdHMgdGhhdCBtaWdodCBiZSBjb3VudGVycHJvZHVjdGl2ZS4N
Cg0KPiBXaGF0IHlvdSByZWFsbHkgd2FudCBpcyBhIHdheSB0byBtYXJrIEEyRFAgY2hhbm5lbHMg
Zm9yIHN0cmVhbWluZyBmcm9tIHVzZXJzcGFjZSBhcyBzdHJlYW1pbmcvcmVhbHRpbWUvcHJpb3Jp
dHkgc28gdGhlIEJsdWV0b290aCBzdWJzeXN0ZW0ga25vd3Mgb24gd2hhdCB0byBkbyB3aXRoIGl0
IGFuZCB0aGF0IHdheSBjYW4gYWxzbyB0ZWxsID4gPiBtYWM4MDIxMSBjb3JyZWN0bHkgYWJvdXQg
Y29leCBzZXR0aW5ncy4NCg0KPiBXZSBhcmUgYWxyZWFkeSBzZXR0aW5ncyBmbHVzaGFibGUgZmxh
Z3MgZm9yIEEyRFAgc3RyZWFtaW5nIGNoYW5uZWxzIGFuZCB0aGVyZSBpcyB3b3JrIG9uZ29pbmcg
Zm9yIFNPX1BSSU9SSVRZIHN1cHBvcnQgd2l0aCBMMkNBUCBzb2NrZXRzLg0KDQpNb3JlIHRoYW4g
dGhlIEEyRFAgY29ubmVjdGlvbiwgaXQgd291bGQgYmUgbW9yZSB1c2VmdWwgdG8gZmluZCBvdXQg
d2hlbiBBMkRQIHN0YXJ0L3N0b3Agc3RyZWFtaW5nIHNvIHRoYXQgd2UgY2FuIGtub3cgd2hlbiB0
byByZWFsbG9jYXRlIHJlc291cmNlIHRvIEJsdWV0b290aC4gSXMgaXQgcG9zc2libGUgdG8gdGFw
IHRoaXMgaW5mb3JtYXRpb24gb3V0IG9mIHRoZSBCbHVldG9vdGggY29yZT8NCkFsc28sIGNhbiB5
b3Ugc3VnZ2VzdCBhIHdheSB0byBnZXQgQTJEUCBzdHJlYW1pbmcgc3RhdHVzLCBpbnF1aXJ5IHN0
YXR1cywgYW5kIFNDTyBhbmQgQUNMIHJvbGUgd2l0aG91dCBhIGhhY2sgaW4gdGhlIEJsdWV0b290
aCBzdWJzeXN0ZW0/DQoNCi1TdXJhag0K
