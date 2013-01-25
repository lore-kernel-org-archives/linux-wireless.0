Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:37062 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605Ab3AYKy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 05:54:58 -0500
Date: Fri, 25 Jan 2013 16:18:27 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 0/7] mwl8k: Adding support for simultaneous AP-STA
 functionality
Message-ID: <20130125104826.GA9204@markyou.marvell.com> (sfid-20130125_115502_720684_254AA0A1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding support for simultaneous AP-STA functionality.
This is preparation for enabling 4-address mode for AP
and client mode. For details about 4-address mode
please refer
http://wireless.kernel.org/en/users/Documentation/iw?highlight=%28WDS%29#Using_4-address_for_AP_and_client_mode


Yogesh Ashok Powar (7):
  mwl8k: Announce simultaneous AP-STA support on AP fw
  mwl8k: Allow adding station interface on AP firmware
  mwl8k: set mac type to MWL8K_MAC_TYPE_SECONDARY_CLIENT
  mwl8k: Enable hw encryption for STA mode on AP fw
  mwl8k: Add/Del self entry for AP interface only
  mwl8k: Choose interface specific calls on vif type
  mwl8k: Do not call STA specific cmds not supported by the AP fw

 drivers/net/wireless/mwl8k.c | 66 ++++++++++++++++++++++++++++++++------------
 1 file changed, 48 insertions(+), 18 deletions(-)

-- 
1.8.0.3

