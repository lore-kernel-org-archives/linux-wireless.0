Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out6.electric.net ([192.162.217.184]:64264 "EHLO
	smtp-out6.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759736AbcDESYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 14:24:49 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: 'Amitkumar Karwar' <akarwar@marvell.com>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Wei-Ning Huang <wnhuang@google.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Sameer Nanda <snanda@google.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Sonny Rao <sonnyrao@chromium.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: RE: [PATCH] mwifiex: add __GFP_REPEAT to skb allocation call
Date: Tue, 5 Apr 2016 16:05:16 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D54DC5395@AcuExch.aculab.com> (sfid-20160405_202452_240079_FA53CAC0)
References: <1459226840-36287-1-git-send-email-wnhuang@chromium.org>
	 <87vb45brxc.fsf@kamboji.qca.qualcomm.com>
	 <CABicQ-UJ1kniq6m86QcyVZBPznvNexfrUrTk3A_=GmZy69hvCA@mail.gmail.com>
 <1459256320.6473.160.camel@edumazet-glaptop3.roam.corp.google.com>
 <4fa3762986eb4b848dbe7daf6871d7a8@SC-EXCH04.marvell.com>
In-Reply-To: <4fa3762986eb4b848dbe7daf6871d7a8@SC-EXCH04.marvell.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RnJvbTogQW1pdGt1bWFyIEthcndhcg0KPiBTZW50OiAwNSBBcHJpbCAyMDE2IDA2OjQ4DQouLi4N
Cj4gT3VyIG9uZSB0aW1lIGFsbG9jYXRlZCA2NGsgYnVmZmVyIHJlYWQgZnJvbSBmaXJtd2FyZSBj
b250YWlucyBtdWx0aXBsZSBkYXRhIGNodW5rcy4gV2UgaGF2ZSBhIGZlYXR1cmUNCj4gY2FsbGVk
IHNpbmdsZSBwb3J0IGFnZ3JlZ2F0aW9uIGluIHdoaWNoIGZpcm13YXJlIGF0dGFjaGVzIGFuIGFn
Z3JlZ2F0ZWQgYnVmZmVyIHRvIHNpbmdsZSBwb3J0LiBTbw0KPiBzb21ldGltZXMgYSBzaW5nbGUg
ZGF0YSBjaHVuayBjYW4gZXhjZWVkIDMyay4gZGV2X2tmcmVlX3NrYl9hbnkoKSBpcyBjYWxsZWQg
dG8gZnJlZSB0aG9zZSBkYXRhIGNodW5rcy4NCg0KQWggeWVzLCB3aGljaCBwYXJ0aWN1bGFyIHBy
b2JsZW0gZG9lcyBhZ2dyZWdhdGluZyBkYXRhIGludG8gYSBzaW5nbGUgYnVmZmVyIHNvbHZlPw0K
DQoJRGF2aWQNCg0K
