Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:55108 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363AbYAKP30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 10:29:26 -0500
From: Michael Buesch <mb@bu3sch.de>
To: ronald645@gmail.com
Subject: Re: Bcm4311 shuts down on closing lid (intended?)
Date: Fri, 11 Jan 2008 16:28:25 +0100
Cc: linux-wireless@vger.kernel.org
References: <47866FE6.4010100@gmail.com> <200801102028.43222.mb@bu3sch.de> <4787021F.4020803@gmail.com>
In-Reply-To: <4787021F.4020803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801111628.26119.mb@bu3sch.de> (sfid-20080111_152930_640647_3925F390)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 11 January 2008 06:43:59 Ronald wrote:
> >> On Thursday 10 January 2008 20:20:06 Ronald wrote:
> >>> Hi,
> >>>
> >>> The b43 driver in the linux kernel 2.6.24-rc7 works really good :) . 
> >>> Keep it up! However, one thing is bugging me: Why does the card stop 
> >>> sending/receiving packets when I close the lid? Is this behaviour 
> >>> intended in the new driver? If yes, can I disable it?
> >> 
> >> I guess the machine goes to suspend, right?
> >> You obviously can't use the machine when it's suspended.
> >> 
>  >Nope, it doesn't go into suspend. With the old driver, I could close 
>  >the lid and for example SSH into it. Now, that is not possible. I 
> tried >it with a radio station. It stops playing after a while once I 
> close >the lid.... . The only thing that changes is that the screen 
> light >shuts down (but not the card! it worked before when closing the 
>  >screen!)

I'm pretty sure there are no lid related routines in the wireless
driver, though. ;) So the problem must be somewhere else.


-- 
Greetings Michael.
