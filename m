Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:37409 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbXKWFlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 00:41:01 -0500
Message-ID: <474667EE.7060100@lwfinger.net> (sfid-20071123_054106_239386_35FB18F8)
Date: Thu, 22 Nov 2007 23:41:02 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John H." <mistamaila@gmail.com>
CC: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: timeout problems with certain APs and b43
References: <5b9417770711211135p65eab873leef65cd0e71452aa@mail.gmail.com>	 <4744AEA1.9020705@lwfinger.net> <5b9417770711222031r28011e75v3a6eb4a7acdf2183@mail.gmail.com>
In-Reply-To: <5b9417770711222031r28011e75v3a6eb4a7acdf2183@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John H. wrote:
> wrt54gs with latest firmware.
> 
> it seems exclusive to linux:O
> 
> On Nov 21, 2007 4:18 PM, Larry Finger <larry.finger@lwfinger.net> wrote:
>> John H. wrote:
>>>  uname -a
>>> Linux laptop 2.6.23.1-49.fc8 #1 SMP Thu Nov 8 21:41:26 EST 2007 i686
>>> i686 i386 GNU/Linux
>>> fedora 8
>>>
>>> on certain APs, the internet works for a long time then stops, and I
>>> get authentication time outs, why?  It usually works again if I reset
>>> the AP itself, which i should not have to do and don't have to if in
>>> XP....
>>>
>>>
>>> wlan0: switched to long barker preamble (BSSID=00:0f:66:53:3e:24)
>>> wlan0: switched to short barker preamble (BSSID=00:0f:66:53:3e:24)
>>>
>>>
>>>
>>> wlan0: Initial auth_alg=0
>>> wlan0: authenticate with AP 00:0f:66:53:3e:24
>>> wlan0: authenticate with AP 00:0f:66:53:3e:24
>>> wlan0: authenticate with AP 00:0f:66:53:3e:24
>>> wlan0: authentication with AP 00:0f:66:53:3e:24 timed out
>> Do you have the opportunity to capture the wireless traffic with a second computer using Kismet or
>> Wireshark when this condition occurs? Without that info, it would be hard to know what might be
>> wrong. Of course, I don't have the problem with either of my AP's.
>>
>> Could you identify the make/model and firmware revisions of any AP's that show this behavior?

Please do not top post!

The problem is not generic with Linksys AP's. I use a WRT54GL V1.1 and a WRT54G V5. Neither shows
the problem.

We need a dump of the wireless traffic when this condition occurs.

Larry
