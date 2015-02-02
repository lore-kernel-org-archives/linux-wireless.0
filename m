Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from milliways.jots.org ([198.204.250.45]:50889 "EHLO
	milliways.jots.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbbBBXaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 18:30:20 -0500
Received: from webmail.jots.org (localhost.localdomain [127.0.0.1])
	by milliways.jots.org (Postfix) with ESMTP id 6B5992BC0F78
	for <linux-wireless@vger.kernel.org>; Mon,  2 Feb 2015 18:24:15 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 02 Feb 2015 18:24:15 -0500
From: Ken D'Ambrosio <ken@jots.org>
To: linux-wireless@vger.kernel.org
Subject: rtl8192ee (Thinkpad T440s)
Message-ID: <10a90ab7a6c186362f339481b531832f@webmail.jots.org> (sfid-20150203_003029_821361_E3B57960)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, all.  Just got a new Thinkpad, and needless to say, tried to fire it 
up on the network.  Ubuntu 14.04 didn't have the driver, so I tried 
14.10, which did.  I thought I was good until I tried to connect; the 
laptop would see all the advertised WAPs, but wouldn't connect to any of 
them (including my security-free ones).  I then downloaded the 3.19 RC 
and tried that -- same deal.  I see a few extra git commits in -next; 
any idea if that will be of any assistance?  Is there anything I can dig 
through in my logs to help flesh out what the problem is?

Thanks!

-Ken
