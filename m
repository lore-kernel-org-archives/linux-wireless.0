Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.polymtl.ca ([132.207.4.11]:42646 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab2C0Oxu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 10:53:50 -0400
Received: from localhost (imp-4-2.polymtl.ca [132.207.4.77])
	by smtp.polymtl.ca (8.14.3/8.14.3) with ESMTP id q2RErm8u029913
	for <linux-wireless@vger.kernel.org>; Tue, 27 Mar 2012 10:53:49 -0400
Message-ID: <1332860028.4f71d47c7ec86@www.imp.polymtl.ca> (sfid-20120327_165353_225822_E1A133C0)
Date: Tue, 27 Mar 2012 10:53:48 -0400
From: Naveen Goswamy <naveen.goswamy@polymtl.ca>
To: linux-wireless@vger.kernel.org
Subject: brcmsmac not working well
References: <1332856558-5708-1-git-send-email-michal.kazior@tieto.com> <1332856558-5708-4-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1332856558-5708-4-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I have the BCM4313 [14e4:4727] (rev 01)

When using wireshark, I see that I am getting many {TCP Retransmission,TCP Dup
ACK,TCP RST} with {TCP, HTTP, SSH} when using brcmsmac driver in the 3.2.1
kernel.  I've tried 3.3-rc5 kernel with similar results.

I notice a lot of these popping up in /var/log/messages as well:

ieee80211 phy0: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 155/256 dur
1746/1504
ieee80211 phy0: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 130/256 dur
1546/1504
ieee80211 phy0: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 130/256 dur
1546/1504


any ideas how to solve this?

Thanks,

Naveen

