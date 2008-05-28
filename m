Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:30648 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbYE1KgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 06:36:19 -0400
Received: by an-out-0708.google.com with SMTP id d40so620767and.103
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2008 03:36:18 -0700 (PDT)
Message-ID: <40f31dec0805280336r40b102ffx11cbd0c0d465c9f8@mail.gmail.com> (sfid-20080528_123624_722780_46CC4293)
Date: Wed, 28 May 2008 13:36:18 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Richard Scherping" <richard@scherping.de>
Subject: Re: ath5k: 10 MHz channels?
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <483B181F.3010802@scherping.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <483B181F.3010802@scherping.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/5/26 Richard Scherping <richard@scherping.de>:
> Hello list!
>
> I have been testing ath5k with some different Atheros devices (Cardbus bg, MiniPCI HighPower abg, MiniPCI HighPower a - exact models available if needed) and found that it works quite well now. Test systems were running Debian 4.0 with Kernel 2.6.22 from backports and compat-wireless 2008-05-17.
>
> While using arbitrary channels worked quite well (got ad-hoc working at 6.1 GHz - in development lab, so no legal problems with that) I do miss the possibility to switch to 10 MHz wide channel operation as it is possible with MadWifi and needed for some 11j modes.
>
> Are there any hints how this might be possible to enable? I can provide analysis of the systems running with MadWifi and 10 MHz channels if needed - just direct me to the right tools ;-)
>
> Thanks in advance for any help!
>
> Richard

No work has been done for such features yet, other more important
things are missing right now. If you want to rev. engineer
half/quarter rate channels, i think you should start from nic_wakeup
and reset functions (also check out rx/tx descriptors for the rate
code). Mmiotrace is your friend ;-)



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
