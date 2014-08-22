Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:45114 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaHVLkU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 07:40:20 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "dsd@gentoo.org" <dsd@gentoo.org>,
	"kune@deine-taler.de" <kune@deine-taler.de>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] zd1211rw: replace ZD_ASSERT with lockdep_assert_held()
Date: Fri, 22 Aug 2014 11:40:15 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF3165A@EU-MBX-02.mgc.mentorg.com> (sfid-20140822_134040_735000_76358BA9)
References: <1407827133-29493-1-git-send-email-sanjeev_sharma@mentor.com>
	 <FDC088D3B5555644AE135ED28A7ABDE94DF2FDC2@EU-MBX-02.mgc.mentorg.com>
	 (sfid-20140819_083957_833442_DEE44B0A)
 <1408707084.4349.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1408707084.4349.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WWVzLCBpdCBjb21waWxpbmcgc3VjY2Vzc2Z1bGx5Lg0KDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQpGcm9tOiBKb2hhbm5lcyBCZXJnIFttYWlsdG86am9oYW5uZXNAc2lwc29sdXRpb25z
Lm5ldF0gDQpTZW50OiBGcmlkYXksIEF1Z3VzdCAyMiwgMjAxNCA1OjAxIFBNDQpUbzogU2hhcm1h
LCBTYW5qZWV2DQpDYzogZHNkQGdlbnRvby5vcmc7IGt1bmVAZGVpbmUtdGFsZXIuZGU7IGxpbnZp
bGxlQHR1eGRyaXZlci5jb207IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDog
UmU6IFtQQVRDSF0gemQxMjExcnc6IHJlcGxhY2UgWkRfQVNTRVJUIHdpdGggbG9ja2RlcF9hc3Nl
cnRfaGVsZCgpDQoNCk9uIFR1ZSwgMjAxNC0wOC0xOSBhdCAwNjozOSArMDAwMCwgU2hhcm1hLCBT
YW5qZWV2IHdyb3RlOg0KPiBQaW5nIGZvciByZXZpZXcgdGhlIHBhdGNoLg0KDQpNYWtlIHN1cmUg
aXQgY29tcGlsZXMgLi4uDQoNCg0KDQo=
