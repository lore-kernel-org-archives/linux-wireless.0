Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:61380 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab3JWPJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Oct 2013 11:09:22 -0400
Received: by mail-oa0-f50.google.com with SMTP id j6so295955oag.37
        for <linux-wireless@vger.kernel.org>; Wed, 23 Oct 2013 08:09:21 -0700 (PDT)
Message-ID: <5267E69F.70804@lwfinger.net> (sfid-20131023_170926_230685_1CE821DF)
Date: Wed, 23 Oct 2013 10:09:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Gianfranco Costamagna <costamagnagianfranco@yahoo.it>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Edimax EW-7733UnD
References: <1382537927.62604.YahooMailNeo@web171801.mail.ir2.yahoo.com> <1382538469.7892.YahooMailNeo@web171805.mail.ir2.yahoo.com>
In-Reply-To: <1382538469.7892.YahooMailNeo@web171805.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/23/2013 09:27 AM, Gianfranco Costamagna wrote:
> Hi Kernel Wireless developers, I write here since I have an issue with this module.
>
>
> We bought 2 of them since they are both 2.4 and 5Ghz capable, and they seem to be powerful enough for our pourposes
> http://www.edimax.com/au/produce_detail.php?pd_id=399&pl1_id=1&pl2_id=44
>
>
> Anyway there is a problem, that the linux kernel seems to be not supporting them
>
> I tried following this guide
> http://wikidevi.com/wiki/Edimax_EW-7733UnD
> rt3573sta, possibly rt5572sta, and future support in rt2800usb "uhosg's patchset adding support, may be in by k3.12"
> but at this moment it is showing an interface with one of them (I cannot connect to anything, the interface shown seems to be incorrect), with another I get a kernel anic and with the third one doesn't work at all.
>
> lsusb |grep Edimax
>
> Bus 002 Device 002: ID 7392:7733 Edimax Technology Co., Ltd
>
> Are you guys working on it? How can I make it work? I'm open to patches, suggestions or whatever can help me in using them

That device was added to the kernel version of rt2800usb in July of 2013, and it 
is in version 3.12-rc6. You can either generate that kernel for your system, or 
you could get the latest backports source and build it.

I am not an expert on the rt2x00 drivers, and I have no idea if it works.

Larry



