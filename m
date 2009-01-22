Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail37.messagelabs.com ([216.82.241.83]:43193 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbZAVVwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 16:52:34 -0500
From: "Gordon, Charles" <Charles.Gordon@digi.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 22 Jan 2009 15:52:30 -0600
Subject: Question on tx field of struct ieee80211_ops
Message-ID: <8DCC153EAFE67A4B990A840E829F704B010A451E5DE9@mtk-sms-exch01.digi.com> (sfid-20090122_225242_540860_F66534C9)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm writing a wireless driver that will use the mac80211 API.  My hardware = allows me to send one packet at a time.  The driver is suppose to set the t= x field (among others) in the struct ieee80211_ops argument passed to ieee8= 0211_alloc_hw().  The tx field should be loaded with a pointer to a low lev= el transmit routine.  However, it's not clear from the documentation if thi= s routine should maintain a packet queue or not.  Is it okay for the low le= vel transmit routine to only allow one packet to be transmitted at a time, = or should it maintain a queue of tx packets?  It seems like the mac80211 AP= I is already maintaining a queue, so I'm not sure that the low level driver=  should maintain a second one.

Thanks for any information you can provide.

