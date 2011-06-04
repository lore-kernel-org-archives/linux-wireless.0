Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm20-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.165]:37270 "HELO
	nm20-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752697Ab1FDIQY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2011 04:16:24 -0400
Message-ID: <682328.58578.qm@web161616.mail.bf1.yahoo.com> (sfid-20110604_101711_600998_E5C971FE)
Date: Sat, 4 Jun 2011 01:16:23 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [RFC PATCH 03/27] zd1211rw: include mac80211.h from zd_chip.h
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>
In-Reply-To: <20110531222451.620004sd89q8uzr7@www.81.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > 
> >> >> Date: Sunday, May 29, 2011, 11:04 PM
> >> >> zd_chip.h contains one function with
> >> >> a pointer to ieee80211_hw but doesn't
> >> >> include mac80211.h. As a temporary
> solution
> >> include
> >> >> mac80211.h to avoid
> >> >> a warning.
> >> >
> >> > I'm still getting a warning with this patch.
> I think
> >> this happened when Jussi fixed some stuff awhile
> back.
> >> >
> >> > In function ‘zd_mac_alloc_hw’:
> >> >
> drivers/net/wireless/zd1211rw/zd_mac.c:1340:7:
> >> warning: statement with no effect
> >> 
> >> Hm.. I'm not getting this with wireless-testing.
> >> 
> > 
> > Ubuntu's default kernels 2.6.35 and .38 exhibit this
> warning when compiling compat-wireless. If my memory serves
> me right, the warning began to occur right after you've
> submitted a patch to rename CR* marcos to ZD_CR*.
> 
> Compiled compat-wireless-2011-05-30 on Ubuntu 11.04, 64bit:
> 2.6.38-8-generic & 2.6.38-8-server and 32bit:
> 2.6.38-8-generic & 2.6.38-8-generic-pae. No warnings at
> zd1211rw at all. (?)
> 

Apologies for the delay. It appears I may have applied an injection patch to the zd1211rw which resulted in the warning reported above. Unfortunately, the zd1211rw does monitor, but will not inject outright.

Walter
