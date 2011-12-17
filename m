Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33623 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab1LQXSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 18:18:10 -0500
Message-ID: <4EED232D.3010208@lwfinger.net> (sfid-20111218_001853_968682_62E11F09)
Date: Sat, 17 Dec 2011 17:18:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Question about TCP Checksum errors
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In https://bugzilla.novell.com/show_bug.cgi?id=718736, a user reports that his 
network using an RTL8188CE becomes very slow under "heavy" load. This condition 
started when he updated from openSUSE 11.4 to 12.1. The kernels involved are 
2.6.37 and 3.1. I am unable to duplicate the problem.

Packet capture with Wireshark shows that the slow down is due to retransmissions 
due to TCP checksum errors. I found nothing to explain the situation with a 
Google search, thus I am asking here.

I put heavy in quotes because the traffic is from a web browser to yahoo.com, 
thus the potential throughput is not very high.

As far as I know, this checksum is generated in a higher layer of the network 
stack, and that data is just passed through the 802.11 layer, and the wireless 
driver. Is this correct? Anyone have any ideas on where to look for the problem?

Thanks,

Larry
