Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from anubis.fsck.tv ([81.187.216.62]:48397 "EHLO anubis.fsck.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbYIGQgY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 12:36:24 -0400
Received: from [192.168.253.32] (ident=root)
	by anubis.fsck.tv with esmtpsa (Exim 4.69 #1 (Debian))
	id 1KcMSz-0001fV-WA
	for <linux-wireless@vger.kernel.org>; Sun, 07 Sep 2008 16:46:22 +0100
Message-ID: <48C3F74D.7020005@fsck.tv> (sfid-20080907_183639_211737_8D70E15E)
Date: Sun, 07 Sep 2008 16:46:21 +0100
From: Jon Wesgate <jon@fsck.tv>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: iwl4965 and 802.11a
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
using your latest compat-2.6-old drivers I'm unable to see my 802.11a 
network.
It used to work ok but has been problematic since kernel 2.6.24.
on 2.6.24 it would show up but I could only connect to it if I turned 
wpa off.
2.6.25 was hopeless and so was 2.6.26 till I updated the Ucode now b/g 
works fine other than having to try twice on encrypted connections and 
the interface going down when the link was reset.
It looks like your latest drivers have fixed that but 802.11a is still 
nowhere to be seen.
I can see 11 networks on 802.11g from here so you can understand that 
the 5 gig band is much better for me.

Many thanks
Jon Westgate
