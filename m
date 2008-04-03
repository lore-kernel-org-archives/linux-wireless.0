Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:36547 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYDCQHz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 12:07:55 -0400
From: Chr <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: SKB BUG: invalid truesize in AP mode
Date: Thu, 3 Apr 2008 18:07:53 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Tomas Winkler <tomasw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804031807.53768.chunkeey@web.de> (sfid-20080403_170759_460371_A9DCA025)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I get lots of:

[ 4439.191058] SKB BUG: Invalid truesize (712) len=543, sizeof(sk_buff)=200                                                                 
[ 4439.730154] SKB BUG: Invalid truesize (712) len=524, sizeof(sk_buff)=200                                                                 
[ 4440.401994] SKB BUG: Invalid truesize (712) len=543, sizeof(sk_buff)=200                                                                 

lately... (even with todays wireless-testing.git)

mostly when I'm testing the p54 ap-mode (station mode is fine)...
but, I got them on my Intel 4965n (iwlwifi in 2.6.25-rc7-git5) too.
nothing bad happend so far, other than MBs of spamming in the logs.
So, is this a known problem and more or less harmless, or not? 

Regards,
	Chr
