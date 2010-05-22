Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:37657 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932376Ab0EVBRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 21:17:05 -0400
Message-ID: <4BF7308D.3010201@dlasys.net>
Date: Fri, 21 May 2010 21:17:01 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: AR9170 FW
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

     I have been playing with the assorted timers in the ar9170.

     My preliminary observations seem to be indicating that
         AR9170_TIMER_REG_TIMER0 might actually be running at 40mhz/25ns,
     But that all the other timers seem to be running far slower - i.e. 
maybe they are cascaded of the overflow on timer0.
     I have specifically looked at timer1-4 and tic_timer and clock_low 
and they all seem to be running very slow.

     The docs that I have imply but do not state that all these clocks 
are directly off the 25ns/40mhz superH clock.

     Have you had any experience with the clocks and their rates ?






-- 
Dave Lynch 					  	    DLA Systems
Software Development:  				         Embedded Linux
717.587.7774 	       dhlii@dlasys.net 	  http://www.dlasys.net
Over 25 years' experience in platforms, languages, and technologies too numerous to list.

"Any intelligent fool can make things bigger and more complex... It takes a touch of genius - and a lot of courage to move in the opposite direction."
Albert Einstein

