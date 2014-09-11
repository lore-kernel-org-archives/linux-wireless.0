Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:57542 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaIKECy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 00:02:54 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "dsd@gentoo.org" <dsd@gentoo.org>,
	"kune@deine-taler.de" <kune@deine-taler.de>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] zd1211rw: replace ZD_ASSERT with lockdep_assert_held()
Date: Thu, 11 Sep 2014 04:02:49 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF4D490@EU-MBX-02.mgc.mentorg.com> (sfid-20140911_060320_595202_42F462F4)
References: <1407827133-29493-1-git-send-email-sanjeev_sharma@mentor.com>
	 <FDC088D3B5555644AE135ED28A7ABDE94DF2FDC2@EU-MBX-02.mgc.mentorg.com>
	 (sfid-20140819_083957_833442_DEE44B0A)
 <1408707084.4349.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1408707084.4349.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEpvaGFubmVzIEJlcmcgW21haWx0bzpq
b2hhbm5lc0BzaXBzb2x1dGlvbnMubmV0XSANClNlbnQ6IEZyaWRheSwgQXVndXN0IDIyLCAyMDE0
IDU6MDEgUE0NClRvOiBTaGFybWEsIFNhbmplZXYNCkNjOiBkc2RAZ2VudG9vLm9yZzsga3VuZUBk
ZWluZS10YWxlci5kZTsgbGludmlsbGVAdHV4ZHJpdmVyLmNvbTsgbGludXgtd2lyZWxlc3NAdmdl
ci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnDQpTdWJqZWN0OiBSZTogW1BBVENIXSB6ZDEyMTFydzogcmVwbGFjZSBaRF9BU1NF
UlQgd2l0aCBsb2NrZGVwX2Fzc2VydF9oZWxkKCkNCg0KT24gVHVlLCAyMDE0LTA4LTE5IGF0IDA2
OjM5ICswMDAwLCBTaGFybWEsIFNhbmplZXYgd3JvdGU6DQo+IFBpbmcgZm9yIHJldmlldyB0aGUg
cGF0Y2guDQoNCj4gTWFrZSBzdXJlIGl0IGNvbXBpbGVzIC4uLg0KDQpBbnkgdXBkYXRlIG9uIHRo
aXMgcGF0Y2ggPw0KDQpSZWdhcmRzDQpTYW5qZWV2IFNoYXJtYQ0KDQo=
