Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29226 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab1JOAtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 20:49:10 -0400
From: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Rishi Panjwani <rpanjwan@qca.qualcomm.com>
Subject: [PATCH] Implement support for QOS-enable and QOS-disable from userspace
Date: Fri, 14 Oct 2011 17:48:06 -0700
Message-ID: <1318639687-28457-1-git-send-email-rpanjwan@qca.qualcomm.com> (sfid-20111015_024914_764023_5BD10776)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement support for QOS-enable and QOS-disable from userspace
    
In order to allow user space based QOS control we use the available debugfs
infrastructure. With this feature, user can make changes to qos parameters,
thereby allowing creation and deletion of user defined priority streams and
features like uapsd. This feature has been added for testing purposes. As
described in the commit description, all parameters are necessary for create_qos
and delete_qos
   
Rishi Panjwani (1):
  ath6kl: Implement support for QOS-enable and QOS-disable from
    userspace

 drivers/net/wireless/ath/ath6kl/debug.c |  250 +++++++++++++++++++++++++++++--
 1 files changed, 236 insertions(+), 14 deletions(-)

