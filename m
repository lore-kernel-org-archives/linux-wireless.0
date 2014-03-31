Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 0.mx.nanl.de ([217.115.11.12]:42180 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbaCaMx2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 08:53:28 -0400
Received: from mail-qa0-f51.google.com (mail-qa0-f51.google.com [209.85.216.51])
	by mail.nanl.de (Postfix) with ESMTPSA id 007284609A
	for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 12:52:55 +0000 (UTC)
Received: by mail-qa0-f51.google.com with SMTP id j7so7965510qaq.38
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 05:53:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1382554536-27943-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382554536-27943-1-git-send-email-mcgrof@do-not-panic.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Mon, 31 Mar 2014 14:53:03 +0200
Message-ID: <CAOiHx=nZduA=A9QOFiUZEJmyv=d9SpO-8Xb-+DpqSRcyJKmRjg@mail.gmail.com> (sfid-20140331_145333_470508_22DEA2A0)
Subject: Re: [RFC] cfg80211: make genregdb.awk skip antenna gain
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 23, 2013 at 8:55 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> Now that wireless-regdb doesn't include
> antenna gain lets skip parsing it completely
> for when CONFIG_CFG80211_INTERNAL_REGDB is
> enabled.
>
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

As far as I can tell, this is still needed for current regdb.txt's (at
least we needed it in OpenWrt). Assuming it wasn't applied because of
RFC, can you resend it as a "proper" patch? One small question though
...

> ---
>  net/wireless/genregdb.awk | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>  mode change 100644 => 100755 net/wireless/genregdb.awk

was this mode change intentional?

> (snip)


Regards
Jonas
