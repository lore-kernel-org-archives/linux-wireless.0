Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55099 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1KGVW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 16:22:28 -0500
Received: by bke11 with SMTP id 11so4024925bke.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Nov 2011 13:22:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111107181135.GD2798@tuxdriver.com>
References: <1319636866-12171-1-git-send-email-arik@wizery.com>
 <20111027142248.GA3972@jm.kir.nu> <20111107181135.GD2798@tuxdriver.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 7 Nov 2011 23:22:11 +0200
Message-ID: <CA+XVXffLpuw-3R3xtcbbJNDgv9LBLO=C4_FKZ2+6beCUJ0D91g@mail.gmail.com> (sfid-20111107_222232_428322_2A534263)
Subject: Re: [PATCH] mac80211: init rate-control for TDLS sta when supp-rates
 are known
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 7, 2011 at 20:11, John W. Linville <linville@tuxdriver.com> wrote:
> I merged this patch from Jouni:
>
>        commit e3a4cc2f073739c9c9c2e97efc774703061f034a
>        Author: Jouni Malinen <j@w1.fi>
>        Date:   Sun Oct 23 22:36:04 2011 +0300
>
>            mac80211: Fix TDLS support validation in add_station handler
>
>            We need to verify whether the command is successful before allocating
>            the station entry to avoid extra processing. This also fixes a memory
>            leak on the error path.
>
>            Signed-off-by: Jouni Malinen <j@w1.fi>
>            Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> I'm not sure what to do with this patch now.  I think I will just drop
> it, and you can send me a new patch that applies on top of Jouni's
> (perhaps even reverting it) as appropriate?

Actually the merged patch from Jouni is unrelated to this fix (and
should have been merged). There's a different patch from Jouni that
should not be applied - "mac80211: Fix STA supported rate
configuration with dummy entry".

I'll resend this one after rebasing to the latest wireless-testing
(there was a conflict).

Arik
