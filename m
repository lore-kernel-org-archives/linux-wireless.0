Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:55834 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757737Ab0EXVQt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 17:16:49 -0400
Message-ID: <4BFAECC0.2000007@dlasys.net>
Date: Mon, 24 May 2010 17:16:48 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: CARL9170 features
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

     I am trying to kick carl9170 1.0.9 into either add-hoc or monitor 
mode or anything else where I can xmit to any wireless device. I do not 
care if the receiving device is interested - so long as the radio ACK's 
the packet, which it should do automatically.

     I tried iwconfig wl_ath mode ad-hoc
     And I get and errror:

root# iwconfig wl_ath mode ad-hoc
Error for wireless request "Set Mode" (8B06) :
     SET failed on device wl_ath ; Device or resource busy.

root# iwconfig wl_ath mode monitor
Error for wireless request "Set Mode" (8B06) :
     SET failed on device wl_ath ; Device or resource busy.

root# iwconfig wl_ath mode master
Error for wireless request "Set Mode" (8B06) :
     SET failed on device wl_ath ; Invalid argument.

I can add something to the driver if needed if you coul recomend another 
wireless driver for a reference.


-- 
Dave Lynch 					  	    DLA Systems
Software Development:  				         Embedded Linux
717.587.7774 	       dhlii@dlasys.net 	  http://www.dlasys.net
Over 25 years' experience in platforms, languages, and technologies too numerous to list.

"Any intelligent fool can make things bigger and more complex... It takes a touch of genius - and a lot of courage to move in the opposite direction."
Albert Einstein

