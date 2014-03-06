Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39409 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbaCFP0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 10:26:31 -0500
Date: Thu, 6 Mar 2014 20:42:18 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 0/2] mwl8k: Fixing sparse warnings
Message-ID: <cover.1394107732.git.yogeshp@marvell.com> (sfid-20140306_162655_461098_A5FE8EF5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixing Sparse warnings.

Yogesh Ashok Powar (2):
  mwl8k: le32_to_cpu is redandant on ioread32
  mwl8k: mwl8k_update_survey can be static

 drivers/net/wireless/mwl8k.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
1.8.3.4

