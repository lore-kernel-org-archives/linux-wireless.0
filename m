Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46582 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1FVMDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 08:03:30 -0400
Subject: Re: about RCU programming
From: Johannes Berg <johannes@sipsolutions.net>
To: Manuel =?ISO-8859-1?Q?S=E1ez?= <manuelsaezr@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTikbn2ABhJm75OZg8EC4LeaukzR=Vw@mail.gmail.com> (sfid-20110622_135425_778622_D5EF9D82)
References: <BANLkTimW6oLjQoEbHGOAnXwbWMYUvK00fw@mail.gmail.com>
	 <BANLkTimUc7Gz0AEKKDZinYpGABnDEBMHDA@mail.gmail.com>
	 <1308736869.3883.13.camel@jlt3.sipsolutions.net>
	 <BANLkTikbn2ABhJm75OZg8EC4LeaukzR=Vw@mail.gmail.com>
	 (sfid-20110622_135425_778622_D5EF9D82)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 14:03:25 +0200
Message-ID: <1308744205.29571.0.camel@jlt3.sipsolutions.net> (sfid-20110622_140349_442407_48945FF3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-22 at 13:54 +0200, Manuel Sáez wrote:
> Thank you for your answer. I have actually read some articles like this ones:
> 
> http://lwn.net/Articles/262464/
> http://lwn.net/Articles/263130/
> 
> I think I understood how I should normally use it, but not how it
> really works. I found lots of code snippets in internet and it seems
> to be very easy to use, but when I try to get more information it gets
> more complicated. Although the code is wrong, do you think it could be
> possible what I want to do? I mean, could it be possible in theory to
> "shift" the header in order to make a ring buffer.

I haven't understood what you want to do, but "shifting" anything would
seem to me to be a write operation.

johannes

