Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:60999 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752967Ab0EWGat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 May 2010 02:30:49 -0400
Message-ID: <4BF8CB98.8030903@dlasys.net>
Date: Sun, 23 May 2010 02:30:48 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: carl9170 1.0.9.1
References: <4BDC001F.9050202@dlasys.net> <201005021452.01101.chunkeey@googlemail.com> <4BF82CEE.8020502@dlasys.net> <201005230334.29866.chunkeey@googlemail.com>
In-Reply-To: <201005230334.29866.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

     When I was attempting to push my ll_temac driver, I was told to use 
dev_err(), dev_warn(), and dev_info() rather than printk(KERN_XXXX. I 
beleive the ar9170 driver already in the kernel tree is doing that. I 
beleive these I tend to create DBG(), ERR() and WARN() macros, because 
during debugging I have been known to reroute the error handling through 
a uart or some other debug port - kind of like you are printf'ing 
through USB in the firmware. Putting it in a macro makes global changes 
easier. Though I think heavy use of macros is now frowned on.

     Just my .02




-- 
Dave Lynch 					  	    DLA Systems
Software Development:  				         Embedded Linux
717.587.7774 	       dhlii@dlasys.net 	  http://www.dlasys.net
Over 25 years' experience in platforms, languages, and technologies too numerous to list.

"Any intelligent fool can make things bigger and more complex... It takes a touch of genius - and a lot of courage to move in the opposite direction."
Albert Einstein

