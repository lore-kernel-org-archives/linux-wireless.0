Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:36232 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbbFOURf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 16:17:35 -0400
Received: by oial131 with SMTP id l131so33936792oia.3
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2015 13:17:34 -0700 (PDT)
Message-ID: <557F32DB.5030001@lwfinger.net> (sfid-20150615_221738_476127_724F7ED3)
Date: Mon, 15 Jun 2015 15:17:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jeff Burdges <burdges@gnunet.org>
CC: b43-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Is b43-fwcutter an option for a BCM4360?
References: <1434398914.2004.11.camel@gnunet.org>
In-Reply-To: <1434398914.2004.11.camel@gnunet.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2015 03:08 PM, Jeff Burdges wrote:
>
> I've a MacBook Air 6.2 with a Broadcom BCM4360 802.11ac adapter
> [14e4:43a0] (rev 03).  It's apparently not supported according to :
>
> https://wireless.wiki.kernel.org/en/users/Drivers/b43
>
> I imagine there is no point in playing around with extracting the
> firmware from the drivers on Yosemite or Mavericks using b43-fwcutter,
> right?
>
> Thanks,
> Jeff
>
> p.s.  I've already tried using the proprietary wl driver, but it crashes
> lots on WPA2 and maybe WPA networks.  I mentioned the error messages
> here :
> https://unix.stackexchange.com/questions/209280/broadcom-wireless-driver-source-vs-dkms

If the wiki says that it is unsupported, then that is correct. That list is kept 
up to date.

Firmware is not your problem. It is the basic drivers not supporting that new 
hardware. Using b43-fwcutter will do no good.

I'm sure that you are aware that only Broadcom can debug the proprietary driver.

I have added the wireless mailing list to get additional exposure.

Larry


