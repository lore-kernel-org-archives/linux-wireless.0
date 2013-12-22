Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:58956 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab3LVXum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Dec 2013 18:50:42 -0500
Received: by mail-bk0-f48.google.com with SMTP id r7so1786053bkg.7
        for <linux-wireless@vger.kernel.org>; Sun, 22 Dec 2013 15:50:41 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Scott S <scotta1265@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: will rtl8192su driver work for 64-bit kernel 3.2.0-23-generic?
Date: Mon, 23 Dec 2013 00:50:04 +0100
Message-ID: <3015747.JIT0jyjz1q@debian64> (sfid-20131223_005045_709421_66A6F7F0)
In-Reply-To: <CAGqmZoR8rXm5hNp6pMfESMM7a31aVpNeeGwxMY1Ng4sUXsJ_tg@mail.gmail.com>
References: <CAGqmZoR8rXm5hNp6pMfESMM7a31aVpNeeGwxMY1Ng4sUXsJ_tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Sunday, December 22, 2013 05:58:12 PM Scott S wrote:
> I'm no guru or developer, so please bear with me.
That's fine.

> I'm looking for a better driver for a Rosewill RNX-N180UBE USB wifi on
> 64-bit Linux Mint 13 (Ubuntu 12LTS Kernel 3.2.0-23) the Ubuntu driver
> is junk+10.
in what way is it junk? Is it crashing/misbehaving, does it lack important
features, is the wifi connection unstable, or is something else bothering
you?

> I found your site from here:
> 
> http://wikidevi.com/wiki/Rosewill_RNX-N180UBE
> it says your driver is under development... ??
Yes, you are referring to "r92su".

> but you have a compile ready source...?
Yes, the source is available from <https://github.com/chunkeey/rtl8192su>.
However this driver is for 3.10+ kernels. AFICT there are no ready
[plans for] backports of the driver for an older kernel version. 

If you are interested in the state and future of r92su you can find some
information in this thread:
<http://www.spinics.net/lists/linux-wireless/msg114213.html>
<http://www.spinics.net/lists/linux-wireless/msg114215.html>
TL;DR: r92su is doomed too.

> Just wonder if you can tell me if it will work, or should I use the
> older one listed there? (r8712u)
>
> Or what?
Oh, you can help with the rtl8192su-mac80211 driver rewrite. This would 
certainly make a difference :-D. Anything other than that: no, not that I
know.

Regards,
Christian
