Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:47164 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbYHUSgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 14:36:46 -0400
Message-ID: <48ADB5C2.2020203@lwfinger.net> (sfid-20080821_203650_315741_A8D72175)
Date: Thu, 21 Aug 2008 13:36:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: PHY TRANSMISSION ERRORS
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I recently switched from a BCM4312/1 to a BCM4311/2 PCIe card. Running 
the latest from wireless-testing, I began seeing the PHY TRANSMISSION 
ERROR storms. None had ever been seen for the BCM4312/1. Since booting 
2.6.26 from wireless-testing, none have been observed.

Is this a regression since 2.6.26, or are these errors really 
intermittent? If you see these, please tell me how frequently they 
occur, and as much about the behavior with kernel version as you know.

Thanks,

Larry
