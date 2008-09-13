Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:63444 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756774AbYIMAaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 20:30:13 -0400
Message-ID: <48CB0993.6020601@lwfinger.net> (sfid-20080913_023019_133533_29510E5E)
Date: Fri, 12 Sep 2008 19:30:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: feldmaus <feldmann_markus@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: Do not get BCM4303 to work
References: <ga2fra$9q$1@ger.gmane.org> <48C5777B.9070106@lwfinger.net> <gaesbd$nv8$1@ger.gmane.org>
In-Reply-To: <gaesbd$nv8$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

feldmaus wrote:
> Larry Finger schrieb:
>> Your card can receive, but not transmit due to a problem with the 
>> rfkill switch handling in b43legacy. I'm working on this problem with 
>> a Ubuntu user, and will post patches as soon as the problem is fixed.
>>
>> Larry
> Thanks for your Support.
> 
> I installed the Kernel 2.6.26-1 as Maximilian said.
> I hope i can try to get my Card to work.
> If you need some Messages then let me know.

The Ubuntu user and I have discovered that his computer needs the 
hp-dmi module that is part of the mainline kernel since 2.6.27-rc6. 
This module handles the rfkill button that does not produce a 
scancode. I think you will need to get that one for you to be able to 
turn the radio on.

Larry
