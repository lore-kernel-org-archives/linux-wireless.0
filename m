Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm20-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.165]:25061 "HELO
	nm20-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757739Ab1EaRqc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 13:46:32 -0400
Message-ID: <176718.65400.qm@web161618.mail.bf1.yahoo.com> (sfid-20110531_194636_248258_59810A5D)
Date: Tue, 31 May 2011 10:46:31 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [RFC PATCH 03/27] zd1211rw: include mac80211.h from zd_chip.h
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>
In-Reply-To: <20110531160301.41337kl145hokrwo@www.81.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> >> Date: Sunday, May 29, 2011, 11:04 PM
> >> zd_chip.h contains one function with
> >> a pointer to ieee80211_hw but doesn't
> >> include mac80211.h. As a temporary solution
> include
> >> mac80211.h to avoid
> >> a warning.
> > 
> > I'm still getting a warning with this patch. I think
> this happened when Jussi fixed some stuff awhile back.
> > 
> > In function ‘zd_mac_alloc_hw’:
> > drivers/net/wireless/zd1211rw/zd_mac.c:1340:7:
> warning: statement with no effect
> 
> Hm.. I'm not getting this with wireless-testing.
> 

Ubuntu's default kernels 2.6.35 and .38 exhibit this warning when compiling compat-wireless. If my memory serves me right, the warning began to occur right after you've submitted a patch to rename CR* marcos to ZD_CR*.

Walter 
