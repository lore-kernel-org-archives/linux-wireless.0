Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n6.bullet.ukl.yahoo.com ([217.146.182.183]:28088 "HELO
	n6.bullet.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753664AbYGKQvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2008 12:51:32 -0400
Message-ID: <48779150.10001@yahoo.co.uk> (sfid-20080711_185136_581227_F0E55AFB)
Date: Fri, 11 Jul 2008 17:58:56 +0100
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>, proski@gnu.org
Subject: Re: [RFC] Try to improve RTL8187B initialization time
References: <200807101851.31985.herton@mandriva.com.br> <48769266.4090407@yahoo.co.uk> <200807102058.32220.herton@mandriva.com.br>
In-Reply-To: <200807102058.32220.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> Em Thursday 10 July 2008 19:51:18 Hin-Tak Leung escreveu:
<snipped>
>> BTW, ndiswrapper won't even build with 2.6.26-rc9.
> 
> On a 2.6.26-rc9 builds ok here (i386), I don't remember to have any extra patch
> needed.

I was looking for more developer-oriented info for ndiswrapper to see if I can
fix the XP 64-bit realtek driver on x86_64 linux to see how it compares with the
new native driver, and found two other places Pavel spends his time on (broadcom
firmware cutter and ndiswrapper). He just committed a patch within the last day
or two to ndiswrapper trunk to fix the build problem I saw - apparently it is
WEXT change scheduled for 2.6.27. I saw it sooner than I should because I
was testing John's new redhat rawhide 2.6.26-rc9 kernel with the new rtl8187b
driver.

If ndiswrapper trunk doesn't work with 64-bit realtek, I am probably going to
dig in to see what's wrong with it. Wish me luck!


