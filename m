Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:40824 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab0DLTWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 15:22:04 -0400
Received: by pzk42 with SMTP id 42so4101921pzk.4
        for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 12:22:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BC2EF3B.2060902@gmail.com>
References: <4BC2EF3B.2060902@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 12 Apr 2010 12:21:41 -0700
Message-ID: <n2k43e72e891004121221rac6e1a98k824bcf370974a00c@mail.gmail.com>
Subject: Re: ath9k compilation error
To: =?UTF-8?Q?Torquil_Macdonald_S=C3=B8rensen?= <torquil@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 12, 2010 at 3:00 AM, Torquil Macdonald Sørensen
<torquil@gmail.com> wrote:
> Hi!
>
> I hope this is the right place to report this. If not, I would appreciate
> directions to the correct mailing list. In that case, sorry for spamming!
> :-)

This is the right list indeed.

> I'm getting an error when compiling the ath9k driver in
> compat-wireless-2010-04-11. The version 2010-04-04 compiles fine after
> fixing a simple
>
> First I do:
>
> ./scripts/driver-select ath9k
>
> The I run "make", and after some time I get the following:
>
>  CC [M]  /home/tmac/src/compat-wireless-2010-04-11/net/mac80211/main.o
> /home/tmac/src/compat-wireless-2010-04-11/net/mac80211/main.c: In function
> ‘ieee80211_alloc_hw’:
> /home/tmac/src/compat-wireless-2010-04-11/net/mac80211/main.c:394: error:
> implicit declaration of function ‘__hw_addr_init’
> make[5]: *** [/home/tmac/src/compat-wireless-2010-04-11/net/mac80211/main.o]
> Error 1
> make[4]: *** [/home/tmac/src/compat-wireless-2010-04-11/net/mac80211] Error
> 2
> make[3]: *** [_module_/home/tmac/src/compat-wireless-2010-04-11] Error 2
> make[2]: *** [sub-make] Error 2
>
>
> I want to try the newest driver because I have a lot of dropout problems
> when using my "Atheros Communications Inc. AR9285 Wireless Network Adapter
> (PCI-Express) (rev 01)"
>
> gcc (Debian 4.4.3-7) 4.4.3

What kernel version are you on?

 Luis
