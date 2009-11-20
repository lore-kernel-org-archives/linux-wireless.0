Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:63169 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbZKTUFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:24 -0500
Received: by gxk26 with SMTP id 26so3280939gxk.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2009 12:05:30 -0800 (PST)
Message-ID: <4B06F685.1020405@lwfinger.net>
Date: Fri, 20 Nov 2009 14:05:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chris Vine <chris@cvine.freeserve.co.uk>
CC: William Bourque <william.bourque@polymtl.ca>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: Fatal DMA error problem with netbook and BCM4312
References: <4AFA09C8.4060602@gmail.com>	<200911131216.43704.mb@bu3sch.de>	<4AFD83CA.2050508@lwfinger.net>	<200911131836.26857.mb@bu3sch.de>	<4AFD9E20.3060501@gmail.com>	<4AFDD1C9.4050402@lwfinger.net>	<4AFDF68C.4040804@polymtl.ca>	<4AFE1E5F.9040009@lwfinger.net>	<4AFEFC2C.5030704@polymtl.ca>	<4B068ED9.5070107@lwfinger.net> <20091120195834.334d8bc0@boulder.homenet>
In-Reply-To: <20091120195834.334d8bc0@boulder.homenet>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/20/2009 01:58 PM, Chris Vine wrote:
> On Fri, 20 Nov 2009 06:43:05 -0600
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> One last check. I would appreciate receiving answers to the following
>> questions. These questions apply to anyone else with this problem.
>>
>> Does the pm_qos patch help your "fatal DMA error" problem,
>> particularly when booted from power-off?
>>
>> If you warm-boot after loading the wl driver, does the patch make any
>> difference?
> 
> What's the date/time of the last patch you posted for this and what
> kernel does it apply to?

Friday 11/13 ar 22:38 CET. The link is at
https://lists.berlios.de/pipermail/bcm43xx-dev/2009-November/006338.html.

The patch is written for wireless-testing, but it should apply on mainline
kernels as well.

Larry

