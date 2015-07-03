Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59949 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754537AbbGCHgk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 03:36:40 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: RE: [PATCH] mwifiex: fix leak of gen_ie storage on exit from
 mwifiex_del_mgmt_ies
Date: Fri, 3 Jul 2015 07:36:30 +0000
Message-ID: <d58dcbd832454922b1189cb80d4176f8@SC-EXCH04.marvell.com> (sfid-20150703_093643_703792_C226E9A0)
References: <1435346976-29030-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1435346976-29030-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> From: John W. Linville [mailto:linville@tuxdriver.com]
> Sent: Saturday, June 27, 2015 1:00 AM
> To: linux-wireless@vger.kernel.org
> Cc: Amitkumar Karwar; Nishant Sarmukadam; Kalle Valo; John W. Linville
> Subject: [PATCH] mwifiex: fix leak of gen_ie storage on exit from
> mwifiex_del_mgmt_ies
> 
> Storage pointed to by gen_ie is allocated with kmalloc, but was never
> freed.
> 
> Coverity CID #1271251
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
