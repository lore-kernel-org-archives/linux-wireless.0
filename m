Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:47592 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab1F2Rt5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 13:49:57 -0400
Message-ID: <4E0B65E1.5000707@01019freenet.de> (sfid-20110629_195001_641956_5D8DCE32)
Date: Wed, 29 Jun 2011 19:50:25 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Ben Greear <greearb@candelatech.com>,
	Michel Alexandre Salim <salimma@fedoraproject.org>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH] ath9k: add module option for disabling
 11n functionality
References: <4E0A2F8A.8010102@fedoraproject.org> <4E0A30CD.9030006@candelatech.com> <BANLkTimRc-SzfeYhiKJ5g9pn3tuUzJM_DQ@mail.gmail.com>
In-Reply-To: <BANLkTimRc-SzfeYhiKJ5g9pn3tuUzJM_DQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez schrieb:
> On Tue, Jun 28, 2011 at 12:51 PM, Ben Greear <greearb@candelatech.com> wrote:
>> On 06/28/2011 12:46 PM, Michel Alexandre Salim wrote:
>>> Some wireless base stations implement 802.11n mode in ways that
>>> open-source drivers cannot handle properly, resulting in very unstable
>>> connections. This patch introduces an '11n_disable' option to the ath9k
>>> driver, similar to the same option for the iwlagn driver.

This is a joke, isn't it? If there are problems, why don't you fix them
instead of disabling the feature?

I know, there are problems with the 11n mode (not just with atheros
chips) - but they seem to be just ignored by a lot of the developers
here. There is a bug report [1] but it seems to be handled as if it was
sent against /dev/null.

Why don't you fix the problems? Why do you ignore them? Why don't you
support people who are willing to spent time for testing?


Kind regards,
Andreas


[1] http://w1.fi/bugz/show_bug.cgi?id=402
