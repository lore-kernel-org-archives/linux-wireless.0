Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:41918 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752140AbYD2Xyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2008 19:54:49 -0400
Message-ID: <4817B548.30303@lwfinger.net> (sfid-20080430_015452_514164_BFD8EF6F)
Date: Tue, 29 Apr 2008 18:54:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Gautam Iyer <gi1242@stanford.edu>, linux-wireless@vger.kernel.org
Subject: Re: b43 reduced performance in Linux-2.6.25
References: <20080429215629.GC17790@stanford.edu> <4817A28E.2050309@lwfinger.net> <20080429233045.GA26484@stanford.edu>
In-Reply-To: <20080429233045.GA26484@stanford.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gautam Iyer wrote:
> 
> I don't have Windows so can't compare to it. But even though I use b43
> by default, I sometimes have to revert to ndiswrapper on weak signals or
> large file transfers. Also ndiswrapper has the power management and
> LED's working correctly, which I could not get working with the b43
> driver.
> 
>> The only specs that we are interested in are those that come from reverse 
>> engineering. If you can provide them, we are very interested.
> 
> I'll poke around a little with this during Summer. It would certainly
> make me a lot happier to use the native b43 drivers than Windows
> drivers...

What LEDS does your interface, and what do they not do? If the only LED you 
have is the one attached to the rfkill switch, then you have not properly 
configured the LED parameters.

Larry
