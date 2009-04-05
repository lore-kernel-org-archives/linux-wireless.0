Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37502 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbZDECoq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Apr 2009 22:44:46 -0400
Received: by fxm2 with SMTP id 2so1437571fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 04 Apr 2009 19:44:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890904032115m7548f967m5020481c660c8f13@mail.gmail.com>
References: <43e72e890904032115m7548f967m5020481c660c8f13@mail.gmail.com>
Date: Sun, 5 Apr 2009 03:44:43 +0100
Message-ID: <3ace41890904041944p6cd60084ub2d05a85373459c3@mail.gmail.com> (sfid-20090405_044449_867287_7875F0B3)
Subject: Re: zd1211 3.0.0.56 "vendor driver" - please help port to zd1211rw
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 4, 2009 at 5:15 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Here is our latest "vendor driver" for the old zd1211. We much prefer
> the in-kernel zd1211rw driver but I've heard a few users with issues
> with some devices. Perhaps this might help a few developers help port
> over any changes. I myself have not looked at this yet.
>
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/zd1211/LinuxUSB_AR2524-3.0.0.56.tgz

Somebody reported some problems with the 3.0.0.56 driver in the zd1211
list a few days ago, and I was wondering where he got it from :-) ...
anyway, if you see an obvious answer with the regression noted in this
mail, it might worth either correcting it or something.

http://sourceforge.net/mailarchive/message.php?msg_name=8c675e9b0904010320j18f49dccub37b65b81d254cb4%40mail.gmail.com

I'll certainly have a look at the vendor driver sometime soon - I use
the AP mode.
