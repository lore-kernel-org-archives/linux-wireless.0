Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:38261 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab3BOCwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 21:52:10 -0500
Received: by mail-pb0-f54.google.com with SMTP id rr4so422674pbb.13
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2013 18:52:10 -0800 (PST)
From: Matteo <matteo.danieletto@gmail.com>
Content-Type: text/plain; charset=us-ascii
Subject: Protocol Stack TCP read/write Parameters
Message-Id: <5D600F60-780E-4B48-B298-E08B581241E3@gmail.com> (sfid-20130215_035215_336540_8FEDA408)
Date: Thu, 14 Feb 2013 18:52:05 -0800
To: linux-wireless@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
it is my first time I write here, so sorry if I am asking something well know but I don't know where I can begin.
I tried to find something from google, but now I have a big confusion in my head.

The problem is that I have to read/modify a few parameters from the TCP/IP protocol stack and more precisely into the Link layer.

The parameters are like the following:

-the total number of original MAC packets transmitted in the sampling interval
-the value of the 802.11 contention window at time k, i.e., the maximum number of slots the node will wait before transmitting a packet at the MAC level
-the total number of MAC retransmissions in the sampling interval

I have to know if it is possible and any guideline so I can start.

Thanks a lot


Matteo