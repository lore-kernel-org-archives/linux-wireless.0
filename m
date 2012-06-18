Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:51812 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441Ab2FRPCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 11:02:45 -0400
Received: by eeke53 with SMTP id e53so1686653eek.11
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 08:02:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340031558.4615.9.camel@jlt3.sipsolutions.net>
References: <1340030798-28992-1-git-send-email-victorg@ti.com>
	<1340031558.4615.9.camel@jlt3.sipsolutions.net>
Date: Mon, 18 Jun 2012 18:02:40 +0300
Message-ID: <CAK80WHYDTiAYDD91RUE+V60iogEeKct2o9qLg7Y_iCZHjp+z9A@mail.gmail.com> (sfid-20120618_170248_215584_82153034)
Subject: Re: [PATCH 0/7] nl/cfg/mac80211: add DFS master ability
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 18, 2012 at 5:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-06-18 at 17:46 +0300, Victor Goldenshtein wrote:
>> In continuation to proposed RFC, this patch set (with hostap patch
>> series) adds support for DFS (Dynamic Frequency Selection) according
>> 802.11h.
>
> Please fix coding style in this patchset first. There are various places
> with bad indentation etc.
>
> johannes
>

I have checked all patches with checkpatch, zero warnings.
Maybe only the cover letter has some style problems?


-- 
Thanks,
Victor.
