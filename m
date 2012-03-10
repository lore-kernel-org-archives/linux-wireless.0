Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173021pub.verizon.net ([206.46.173.21]:44855 "EHLO
	vms173021pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310Ab2CJExr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 23:53:47 -0500
Received: from vznit170060 ([unknown] [192.168.1.3]) by vms173021.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0M0N00CCIK9G9I42@vms173021.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Fri, 09 Mar 2012 22:53:40 -0600 (CST)
Date: Fri, 09 Mar 2012 22:53:40 -0600 (CST)
From: alupu@verizon.net
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Message-id: <12012339.37222.1331355220163.JavaMail.root@vznit170060> (sfid-20120310_055350_256757_BEBB7348)
Subject: Re: r8712u staging in kernel 3.2.9
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 03/09/12, 09:17 PM, Larry Finger wrote:
> I was surprised to see you using my
> ESSID of "radius", and my WEP key ...

Hi Larry,

You don't need to be. It has always been our intention to
come as close as possible to comparing apples to apples.
You were gracious enough to install wireless tools _v29_
to accommodate me. I tried to reciprocate by using _exactly_ the
values for essis and key you did. Just for argument's sake,
any other values I could've used (practically an infinite array
- the complimentary set) would've raised the suspicion that 
that "unfortunate" choice might be responsible for the problem.
And we'd hate that, wouldn't we?

> I have no idea what is going wrong on your system ...

In general, I wouldn't be so hasty in blaming my system.
It's _very_ possible, but not proven yet. There's nothing
to gain in finger pointing. The object of the game is
to see what and where the problem is. We'll both come
out heads up high if we deal with the situation
professionally, as we are.

Speaking of this, I've been wondering if there's a possibility
that the firmware is somewhat bad (corrupted, wrong, etc)
I did "describe" it in my Mar 6 07:15 PM post,
for convenience, I repeat it here:

[~]$ ls -l /lib/firmware/rtlwifi
-rw-r--r-- 1 alex users 129304 2012-03-04 15:42 rtl8712u.bin

I assumed, your original acceptance of this file (size, etc.)
was an implicit assuaging of my above concern, but one never knows,
do one?

There's another possibility that the Rosewill Wireless Adapter,
RNX-N180UBE, uses a non-"standard" chip, design, etc..
Have you tested your driver with this particular device?
What other devices and/or systems have you validated your
driver with?
Etc., etc.
Anyway, the point is to troubleshoot the problem and not to
speculate about it. Any suggestions, help are welcome as always.

Regards,
-- Alex
