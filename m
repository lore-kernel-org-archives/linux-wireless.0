Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.230]:59054 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbXDAC3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2007 22:29:36 -0400
Received: by wr-out-0506.google.com with SMTP id 76so1160131wra
        for <linux-wireless@vger.kernel.org>; Sat, 31 Mar 2007 19:29:36 -0700 (PDT)
Message-ID: <a44ae5cd0703311929u7b78dcaeg4d96440d3cfbd034@mail.gmail.com>
Date: Sat, 31 Mar 2007 19:29:31 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: wireless <linux-wireless@vger.kernel.org>
Subject: Why doesn't ipw2200 enable the kill switch LED?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am running 2.6.21-rc5-mm3 + hotfixes.
In order to get the WIFI kill switch and the WIFI "active" LEDs to
light up, I have to:
         echo 1 > /sys/bus/pci/drivers/ipw2200/0000\:01\:06.0/led
There is a bug in Ubuntu's Launchpad bug database on this, and several other
people have encountered this problem.  These folks are hacking their initscripts
to get this working, but it seems to me that the driver should handle this.

What do you say?
          Miles
