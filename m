Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41728 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab3LTIpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Dec 2013 03:45:20 -0500
From: "BAHINI, Henri" <hbahini@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "Chauhan, Rajesh" <rajeshc@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Johnson, Jeff" <jjohnson@qca.qualcomm.com>,
	"Chang, Leo" <schang@qca.qualcomm.com>,
	"Luo, Xun" <xunl@qca.qualcomm.com>,
	"Thalappil, Sameer" <sameert@qca.qualcomm.com>,
	"Hussain, Arif" <c_arifh@qca.qualcomm.com>
Subject: RE: [PATCHv3] cfg80211: add support for frequency interference event
Date: Fri, 20 Dec 2013 08:45:07 +0000
Message-ID: <8AC12462F1AA0E4EA8FEB46307AAD6F650AAB222@nasanexd02f.na.qualcomm.com> (sfid-20131220_094524_148134_77316BFE)
References: <1384198356-427-1-git-send-email-rajeshc@qca.qualcomm.com>
 <1386077130.4393.21.camel@jlt4.sipsolutions.net>
 <CAB=NE6Xa-bdLQm8uAg9wCE0fdp4KPBZ46d5FHVHp6wCvN5=dUA@mail.gmail.com>
 <1386145204.4284.4.camel@jlt4.sipsolutions.net>
 <1386145241.4284.5.camel@jlt4.sipsolutions.net>
 <D19FD2B13A40CD4B8DA64DB9B8F112E93E5CF51C@nasanexd01a.na.qualcomm.com>
 <CAB=NE6VNZDwGj4WWkgCmWxs_xLBZhXn44vo0TEdqo84xsRbZ2Q@mail.gmail.com>
 <8AC12462F1AA0E4EA8FEB46307AAD6F650AAB068@nasanexd02f.na.qualcomm.com>
 <CAB=NE6W3Et-4mDEet5DSDrM=yP60oODvEUGz=RtZj-gDgLNUbw@mail.gmail.com>
 <8AC12462F1AA0E4EA8FEB46307AAD6F650AAB122@nasanexd02f.na.qualcomm.com>
 <CAB=NE6WFOsjRgPyGjudc4c4JVoF-v=nnz2grknOai6=rYxrApA@mail.gmail.com>
In-Reply-To: <CAB=NE6WFOsjRgPyGjudc4c4JVoF-v=nnz2grknOai6=rYxrApA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SSBkbyBhcHByZWNpYXRlIHlvdXIgZmVlZGJhY2sgYW5kIHVuZGVyc3RhbmRpbmcsIEx1aXMuDQoN
ClBsZWFzZSBjb25zaWRlciB0aGF0IHRoZSB3Y24zNnh4IGRyaXZlciB0aGF0IGlzIGFscmVhZHkg
dXAgc3RyZWFtZWQgd2lsbCBtYWtlIHVzZWQgb2YgdGhpcyBBUEkgaW4gZHVlIGNvdXJzZTogaXQg
aXMgYWxyZWFkeSBpbiB0aGUgcGxhbm5pbmcgaW4gdGhlIGNvdXJzZSBvZiBmaXJzdCBoYWxmIG9m
IG5leHQgeWVhciBhcyB3ZSBpbnRlbnNpZnkgdGhlIHB1c2ggb2Ygc29tZSBvZiBvdXIgZmVhdHVy
ZXMgdG8gdGhpcyBkcml2ZXIuDQpQbGVhc2UgYWxzbyBjb25zaWRlciB0aGF0IHRoZSBjb3JyZXNw
b25kaW5nIGNoYW5nZXMgaW4gdGhlIHN1cHBsaWNhbnQgd2lsbCBiZSBwaWNrZWQgdXAgYnkgSm91
bmkncyB0cmVlIGFzIHNvb24gYXMgdGhpcyBjZmc4MDIxMSBBUEkgaXMgdXAgc3RyZWFtZWQuIEpv
dW5pIGNhbiB2b3VjaCBmb3IgdGhpcy4NCg0KV2l0aCBhYm92ZSwgSSBhcHByZWNpYXRlIHlvdSBn
dXlzIGNvbnNpZGVyaW5nIHRoaXMgQVBJLg0KDQpUaGFua3MsDQotSGVucmkgDQo=
