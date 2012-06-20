Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:57473 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754049Ab2FTQu5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 12:50:57 -0400
Received: by lbol5 with SMTP id l5so894690lbo.20
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 09:50:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340182143.4655.43.camel@jlt3.sipsolutions.net>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	<1340111463-4554-7-git-send-email-victorg@ti.com>
	<1340182143.4655.43.camel@jlt3.sipsolutions.net>
Date: Wed, 20 Jun 2012 19:50:54 +0300
Message-ID: <CAK80WHa2r4c_fNPga+eMPczkr9BJ4SAVENcsAmJFqvr3kYZ_zA@mail.gmail.com> (sfid-20120620_185100_908845_3789593D)
Subject: Re: [PATCH v2 7/7] mac80211: add DFS support to monitor interface
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2012 at 11:49 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-06-19 at 16:11 +0300, Victor Goldenshtein wrote:
>
>> +     bool dfs_supported = !!(local->hw.wiphy->features &
>> +                             NL80211_FEATURE_DFS);
>
> No need for !!, also why not inline that into the condition?
>

I will remove the "!!", and if it's ok with you I would prefer to
leave the "dfs_supported" flag, I think it a bit simplifies this big
"if" statement.

-- 
Thanks,
Victor.
