Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.polymtl.ca ([132.207.4.11]:43364 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab2C0QnD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 12:43:03 -0400
Received: from localhost (imp-4-1.polymtl.ca [132.207.4.76])
	by smtp.polymtl.ca (8.14.3/8.14.3) with ESMTP id q2RGh1Nr023819
	for <linux-wireless@vger.kernel.org>; Tue, 27 Mar 2012 12:43:01 -0400
Message-ID: <1332866581.4f71ee152ce84@www.imp.polymtl.ca> (sfid-20120327_184311_346221_00E2D26A)
Date: Tue, 27 Mar 2012 12:43:01 -0400
From: Naveen Goswamy <naveen.goswamy@polymtl.ca>
To: linux-wireless@vger.kernel.org
Subject: brcmsmac TCP problems and txop exceeded
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, this thread should be a continuation of one I started about a month ago and
can be found here:

http://comments.gmane.org/gmane.linux.kernel.wireless.general/86324

(I lost the header to it and inadvertantly cross posted into another thread, my
apologies for that)



So here goes:

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


Regards,

ng
