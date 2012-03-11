Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173007pub.verizon.net ([206.46.173.7]:35156 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab2CKWgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2012 18:36:21 -0400
Received: from vms170029 ([unknown] [192.168.1.3]) by vms173007.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0M0Q00C9ZS4E1L70@vms173007.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Sun, 11 Mar 2012 17:36:15 -0500 (CDT)
Date: Sun, 11 Mar 2012 17:36:14 -0500 (CDT)
From: alupu@verizon.net
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Message-id: <17646354.573873.1331505374568.JavaMail.root@vms170029> (sfid-20120311_233624_579749_5CEFC953)
Subject: Re: r8712u staging in kernel 3.2.9
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

A few _quick_ notes ("impressions") so you can get me more/detailed
instructions while I'm getting the hang of openSUSE :)

> Could you please download a Live KDE CD from
> software.opensuse.org/121/en
> It should not matter whether you use the 32- or 64-bit version.
> After you boot it, use the NetworkManager system tray
> applet to connect to your system.
> Does that work?

Yes. How? Very smoothly.

> Next, use 'ps ax' to get the PID for NetworkManager and kill it.
> Then try your iwconfig/ifconfig command sequence.
> Does that work?

No. Same old story.
Actually, I tried the "iwconfig/ifconfig" (from the KDE terminal) first.
It didn't work so then, quite discouraged, I went to the NM above.
As I said, worked AOK, I then killed the guy, so I can try
the "iwconfig/ifconfig" again. No cigar, as I explained above.

Note: in retrospect, I'm wondering if in Knoppix what would've
happened if I had tried his graphics mode (some sort of KDE clone).
An even bigger wonder. I'll be looking into that:
When doing 'ps ...' I noticed there was a wpa_supplicant(?) running.
If that was a requirement for NM, it should've helped when I went "down"
in command (KDE terminal) mode as well. ???
I don't remember if the supplicant process was killed (as a side effect).

Thanks,
-- Alex
