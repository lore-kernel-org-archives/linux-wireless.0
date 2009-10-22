Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51411.mail.re2.yahoo.com ([206.190.39.152]:42267 "HELO
	web51411.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756042AbZJVNfb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 09:35:31 -0400
Message-ID: <205883.26449.qm@web51411.mail.re2.yahoo.com>
Date: Thu, 22 Oct 2009 06:35:36 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: RE: AP mode with ath5k/ath9k and hostapd 0.6.9 not working, probable bug found
To: linux-wireless@vger.kernel.org
Cc: hostapd list <hostap@lists.shmoo.com>, ath9k-devel@lists.ath9k.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Investigating the ath9k traces further shows, that the beacons have correct sequence numbers while
all Probe Responses have 0 (zero).

 -- 
Regards 
Joerg 


      
