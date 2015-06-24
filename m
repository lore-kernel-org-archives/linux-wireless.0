Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32834 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799AbbFXNHr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2015 09:07:47 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Avinash Patil <patila@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: RE: [PATCH] mwifiex: do not short circuit exit from
 mwifiex_set_mgmt_ies
Date: Wed, 24 Jun 2015 13:07:19 +0000
Message-ID: <25050cfd0593480e9c9023f5af1e4159@SC-EXCH04.marvell.com> (sfid-20150624_150749_881740_A29EC094)
References: <1435086243-10433-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1435086243-10433-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> From: John W. Linville [mailto:linville@tuxdriver.com]
> Sent: Wednesday, June 24, 2015 12:34 AM
> To: linux-wireless@vger.kernel.org
> Cc: Amitkumar Karwar; Avinash Patil; Kalle Valo; John W. Linville
> Subject: [PATCH] mwifiex: do not short circuit exit from
> mwifiex_set_mgmt_ies
> 
> Without this change, the code simply exits after calling
> mwifiex_uap_set_head_tail_ies, leving the call to
> mwifiex_set_mgmt_beacon_data_ies as dead code.
> 
> Coverity CID #1271292
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks,
Amitkumar
