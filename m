Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:42435 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZHNP1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 11:27:08 -0400
Received: by fxm11 with SMTP id 11so1231465fxm.39
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 08:27:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A85678E.6080205@lwfinger.net>
References: <4A854FDF.5020208@gmail.com> <4A855FEA.7030907@lwfinger.net>
	<69e28c910908140602x3873f30bt95b5c148305a5e1e@mail.gmail.com>
	<4A856258.10500@lwfinger.net> <69e28c910908140623r6f158a89pcf145bad7b244af8@mail.gmail.com>
	<4A85678E.6080205@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 14 Aug 2009 17:26:48 +0200
Message-ID: <69e28c910908140826v6725a109u1d6e827869c4ffff@mail.gmail.com>
Subject: Re: [PATCH] b43: Add LP-PHY firmware loading support
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Restored CCs.)

2009/8/14 Larry Finger <Larry.Finger@lwfinger.net>:
> Gábor Stefanik wrote:
>>
>> On http://bu3sch.de/gitweb?p=b43-tools.git;a=blob;f=fwcutter/fwcutter_list.h;hb=HEAD,
>> it doesn't look like v4.150.10.5 contains rev16 - there is one version
>> that does have it, but the link to that file is dead.
>
> The rev 16 firmware definitely is in driver 4.174.64.19, but not in
> 4.150.10.5. I'll have to figure out where I got it, and what
> modifications are needed in fwcutter to make it available.
>
> I suggest that you do the mods to the firmware loading. If Broadcom
> has it in their driver, there must be hardware that needs it.
>
> Larry

I would say that's a goal for later - the FIFO sizes are different, so
it would clearly need more work than just loading the firmware  to
support rev16 devices.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
