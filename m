Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:59457 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811Ab2FTKra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 06:47:30 -0400
Received: by lbbgg6 with SMTP id gg6so441863lbb.36
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 03:47:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE1A734.4090100@neratec.com>
References: <1340030798-28992-1-git-send-email-victorg@ti.com>
	<4FE1A734.4090100@neratec.com>
Date: Wed, 20 Jun 2012 13:47:26 +0300
Message-ID: <CAK80WHbJZMsoV625hT_sQaEvVx3A5XC8M7PH6KfjdCx=MhdtEw@mail.gmail.com> (sfid-20120620_124733_711566_7006F14C)
Subject: Re: [PATCH 0/7] nl/cfg/mac80211: add DFS master ability
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, adrian.chadd@gmail.com, j@w1.fi,
	johannes@sipsolutions.net, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2012 at 1:34 PM, Zefir Kurtisi
<zefir.kurtisi@neratec.com> wrote:
> On 06/18/2012 04:46 PM, Victor Goldenshtein wrote:
>> In continuation to proposed RFC, this patch set (with hostap patch series) adds support for DFS (Dynamic Frequency Selection) according 802.11h.
>>
>> [...]
>
> Thanks for the updated patches, Victor.
>
> Going to test them by preparing the ath9k interface.
>
> Right now they do not apply on top of wireless-testing, could you please
> rebase? Thanks.

The patches are on top of the master branch from:
git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git

-- 
Thanks,
Victor.
