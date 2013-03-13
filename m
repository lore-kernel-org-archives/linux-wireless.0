Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:6911 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755526Ab3CMOet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 10:34:49 -0400
Message-ID: <ab0c8890a5b689123ba8a42591073461.squirrel@www.infidigm.net> (sfid-20130313_153453_270396_DF50AB1B)
In-Reply-To: <CADwvPCtse3oQFXA6pun6udK2r62sAwCGncWfSMCiF9MF0YYTzg@mail.gmail.com>
References: <ccfc79b224366f1bf963e81b78413b2d.squirrel@www.infidigm.net>
    <CADwvPCsk2is8doPmbMuSTNC0CB6Zi_t0Z-D9FUFchiC9e0BZpg@mail.gmail.com>
    <e96eef3b43e416010faf699295f0e2dc.squirrel@www.infidigm.net>
    <CADwvPCtse3oQFXA6pun6udK2r62sAwCGncWfSMCiF9MF0YYTzg@mail.gmail.com>
Date: Wed, 13 Mar 2013 11:37:29 -0400
Subject: Re: Silex SX-SDCAN (AR6003) sdio module, mmc0 timout on imx35
 platform
From: drwho@infidigm.net
To: "Johannes Braun" <jjo.braun@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Are you using a freescale kernel or mainline kernel?  freescale kernels
>> change from one ltib to the next.  My ltib that supports imx51 may have
>> had the sdhci driver rewritten since the ltib that first supported
>> imx35.
>>
>
> I am using a mainline kernel. I don`t want to use freescale`s ltip,
> because the kernel version is very old.

If you have an imx35 dev board from freescale that you can attach the
AR6003 to, I would try that with ltib L2.6.31_09.12.01 and compat 3.8.  I
can show you how to get compat 3.8 to build in ltib.

Jon

