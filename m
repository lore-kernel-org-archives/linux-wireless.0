Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:61082 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbZHNNKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 09:10:51 -0400
Received: by pzk34 with SMTP id 34so1038374pzk.4
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 06:10:52 -0700 (PDT)
Message-ID: <4A856258.10500@lwfinger.net>
Date: Fri, 14 Aug 2009 08:10:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Add LP-PHY firmware loading support
References: <4A854FDF.5020208@gmail.com> <4A855FEA.7030907@lwfinger.net> <69e28c910908140602x3873f30bt95b5c148305a5e1e@mail.gmail.com>
In-Reply-To: <69e28c910908140602x3873f30bt95b5c148305a5e1e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> 
> Is rev.16 firmware available anywhere?
> 

finger@larrylap:~/wireless-testing> ls /lib/firmware/b43
a0b0bsinitvals4.fw   a0g1bsinitvals5.fw   b0g0initvals13.fw
lp0initvals13.fw    n0initvals16.fw        ucode15.fw
a0b0gsinitvals5.fw   a0g1bsinitvals9.fw   b0g0initvals13.fw_save
lp0initvals14.fw    pcm4.fw                ucode16.fw
a0g0bsinitvals4.fw   a0g1initvals13.fw    b0g0initvals4.fw
lp0initvals15.fw    pcm5.fw                ucode4.fw
a0g0bsinitvals5.fw   a0g1initvals5.fw     b0g0initvals5.fw
lp0initvals16.fw    sslpn0bsinitvals16.fw  ucode5.fw
a0g0bsinitvals9.fw   a0g1initvals9.fw     b0g0initvals9.fw
n0absinitvals11.fw  sslpn0initvals16.fw    ucode9.fw
a0g0initvals4.fw     b0g0bsinitvals13.fw  lp0bsinitvals13.fw
n0absinitvals13.fw  ucode11.fw
a0g0initvals5.fw     b0g0bsinitvals4.fw   lp0bsinitvals14.fw
n0bsinitvals11.fw   ucode13.fw
a0g0initvals9.fw     b0g0bsinitvals5.fw   lp0bsinitvals15.fw
n0bsinitvals16.fw   ucode13.fw_save
a0g1bsinitvals13.fw  b0g0bsinitvals9.fw   lp0bsinitvals16.fw
n0initvals11.fw     ucode14.fw

I installed my firmware using openSUSE's script called
/usr/sbin/install_bcm43xx_firmware, which uses the driver file
broadcom-wl-4.150.10.5.tar.bz2, and rev 16 firmware is there.

Larry



