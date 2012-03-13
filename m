Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173011pub.verizon.net ([206.46.173.11]:51799 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab2CMFNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 01:13:48 -0400
Received: from vznit170064 ([unknown] [192.168.1.3]) by vms173011.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0M0T004N92EFT110@vms173011.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Mon, 12 Mar 2012 23:13:28 -0500 (CDT)
Date: Mon, 12 Mar 2012 23:13:27 -0500 (CDT)
From: alupu@verizon.net
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Message-id: <150212.391479.1331612008032.JavaMail.root@vznit170064> (sfid-20120313_061352_467414_39C96086)
Subject: Re: r8712u staging in kernel 3.2.9
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 > On 03/12/12, 8:54 PM Larry Finger wrote:

> You need to use YOUR essid and WEP key.
> Once you enter the 'iwconfig wlan0 essid xxxxxx', that triggers
> the association step, and it will never be able to see MY AP from your location.
> After association, then entering the WEP key will start the authentication.
> Similarly, I think it will not report back the essid unless 
> that AP has been seen in a scan, but that is hard to test.
> Please try again using your values.

I did try that numerous times. To paraphrase you, I'm not stupid!
I replaced _your_ values in my report because you decided to out them
for public consumption anyway and also to be able to compare our
logs line by line more easily.

Please trust me,
IT DOES NOT WORK.
I can plug in my trusted values (validated to work with other computers
and my AP) in any combination,
 iwconfig wlan0 essid ...
 iwconfig wlan0 key restricted ...
 iwconfig wlan0 essid ... key restricted ...

IT JUST DOES NOT WORK.
Try to absorb this info like a man.

Regards,
-- Alex
