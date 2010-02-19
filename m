Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f200.google.com ([209.85.210.200]:65284 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0BSPty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 10:49:54 -0500
Received: by yxe38 with SMTP id 38so169994yxe.4
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2010 07:49:53 -0800 (PST)
Message-ID: <4B7EB31D.2000603@lwfinger.net>
Date: Fri, 19 Feb 2010 09:49:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/11] b43: N-PHY: add some registers and structs definitions
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com> <1266591292.15178.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1266591292.15178.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/19/2010 08:54 AM, Johannes Berg wrote:
> Out of curiosity, how far along is this stuff in general?
> 
> I have a rev 16 core, but right now I can't find the right firmware
> (yes, I should be able to dig it out, but maybe you know off-hand?)

I got my latest firmware (version 508.1107 (2009-06-26 19:16:02)) from:

http://www.linksysbycisco.com/gpl/wrt610n_v2.00.00.05_us.tar.gz

The binaries are in directory wrt610n_v2.00.00.05_us/release/src/wl/linux/. I
used Daniel Lenski's script named b43_fwcutter.py to extract the firmware from
wl_apsta.o. Included are ucode_2w20 - Rev 20 802.11 cores have an SSLPN PHY.

>From my firmware directory, I see ucode16 firmware for LP N and SSLPN PHYs. From
your question to Rafał, yours must be an N PHY.

Larry
