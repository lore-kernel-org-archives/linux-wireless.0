Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f171.google.com ([209.85.210.171]:43003 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3A2Bxo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 20:53:44 -0500
Received: by mail-ia0-f171.google.com with SMTP id z13so5276979iaz.30
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2013 17:53:44 -0800 (PST)
Message-ID: <51072B95.10101@gmail.com> (sfid-20130129_025347_751960_9A24ABBA)
Date: Mon, 28 Jan 2013 20:53:25 -0500
From: Dylan <dylandonkersgoed@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: rtl8723ae Weak Signal Problems
References: <51072B15.2030805@gmail.com>
In-Reply-To: <51072B15.2030805@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quick summary if you don't want to read my rambling:

  * Using the compat-drivers-3.8-rc5-1-u package
  * Using the rtl8723ae chipset and driver
  * Experiencing extremely weak signal
  * No clue what information I need to submit - I'm not having any clear
    crashes or anything, just a way-weaker-than-appropriate signal with
    a driver change being the only issue
  * Seems to have problems with Cisco access points (can't connect at
    all) but I'm not 100% certain

-----------------------------------------------------------------------------------------------------------------------------------------

So, I have a very specific issue with rtl8723ae chipset. I'm not having 
huge expectations of success but figure I'll just send this out there in 
the hopes that someone can help me. I'm using the 
compat-drivers-3.8-rc5-1-u package (the latest stable as of the time of 
this writing) which I'm pleased to see now includes the rtl8723ae 
drivers. Not a moment too soon as the hard-found drivers from Realtek no 
longer seem to work with the new kernels. Unfortunately, I'm now 
experiencing severely reduced signal strength and I'm not sure why. This 
adapter didn't have the best signal strength to begin with but was 
useable (again after a lot of effort). Now...I had this very same 
problem before. Then it was a lot better for the past few months. I'm a 
little hazy about what happened in between. I guess I 
did...something?...to fix it. I wish I remembered what. At any rate I 
now have to move downstairs closer to my router to be able to connect, 
and I have a very poor connection from in my room (it disconnected 
frequently and while it can reconnect on it's own it's still pretty 
annoying and causes a lot of problems).

Small piece of extra information: I actually haven't tested this yet 
with the compat driver (I wouldn't expect a change from the Realtek one) 
since I just switched to it the other day, but the rtl8723ae Linux 
driver (at least the one I was using before from Realtek) seems to be 
unable to connect to my school's Cisco access points OR the old Cisco 
access point provided by my ISP - I believe it's a problem connecting to 
Cisco access points in general since one of the networking teachers at 
my school mentioned some newer Windows 8 drivers having similar problems


