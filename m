Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:15733 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751145AbdJ0TBm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 15:01:42 -0400
From: Ryan Hsu <ryanhsu@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        Thorsten Leemhuis <linux@leemhuis.info>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k-regression due to "ath10k: fix napi_poll budget overflow"
 c9353bf483d3
Date: Fri, 27 Oct 2017 19:01:32 +0000
Message-ID: <72e73df5-c261-cb1a-7fba-b1a3a9019fea@qti.qualcomm.com> (sfid-20171027_210254_698603_6BE600E1)
References: <5a4860eb-3734-7587-d81f-9c3de6ff11c8@leemhuis.info>
 <46f918c5-b07d-e397-2f3d-8136c7c1a8f3@qti.qualcomm.com>
 <fa6e3ee2-91b5-a54b-afe3-87f30aac7a48@leemhuis.info>
 <877evh53p8.fsf_-_@kamboji.qca.qualcomm.com>
In-Reply-To: <877evh53p8.fsf_-_@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gMTAvMjcvMjAxNyAwMjo0MCBBTSwgS2FsbGUgVmFsbyB3cm90ZToNCg0KPiArIGxpbnV4LXdp
cmVsZXNzDQo+DQo+IFNvcnJ5LCBJIGhhdmUgbm90IGJlZW4gYWJsZSB0byBmb2xsb3cgdGhpcyBk
aXNjdXNzaW9uIHZlcnkgY2xvc2VseSBidXQNCj4gd2FzIHRoZSBjb25jbHVzaW9uPyBTaG91bGQg
d2Ugc2hvdWxkIHJldmVydCBjOTM1M2JmNDgzZDMgZm9yIDQuMTQgb3INCj4gd2hhdD8gSSBzaG91
bGQgc3RpbGwgaGF2ZSB0aW1lIHRvIGRvIHRoYXQsIGJ1dCBub3QgbXVjaC4NCg0KS2FsbGUsIEkg
ZG9uJ3QgdGhpbmsgSSBoYXZlIGVub3VnaCB0aW1lIHRvIGxvb2sgaW50byB0aGUgaXNzdWUsIHNp
bmNlIG9yaWdpbmFsIGNoYW5nZSBpcyB0byBhdm9pZCB0aGUgd2FybmluZywgYnV0IG5vdyBpcyBo
YXZpbmcgcmVncmVzc2lvbi4NCkxldCdzIHRyeSB0byByZXZlcnQgYzkzNTNiZjQ4M2QzIGZvciA0
LjE0LCBhbmQgSSdsbCBsb29rIGludG8gdGhpcyBsYXRlci4NCg0KLS0gDQpSeWFuIEhzdQ0K
