Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13929 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbbDIMII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2015 08:08:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yanbo Li <yanbol@qca.qualcomm.com>
CC: <dreamfly281@gmail.com>, <linux-wireless@vger.kernel.org>,
	<michal.kazior@tieto.com>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Change the fw stats access mask
References: <1427476680-5532-1-git-send-email-yanbol@qca.qualcomm.com>
Date: Thu, 9 Apr 2015 15:08:01 +0300
In-Reply-To: <1427476680-5532-1-git-send-email-yanbol@qca.qualcomm.com> (Yanbo
	Li's message of "Fri, 27 Mar 2015 10:18:00 -0700")
Message-ID: <87vbh5ec7y.fsf@kamboji.qca.qualcomm.com> (sfid-20150409_140811_764967_959F2FEB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yanbo Li <yanbol@qca.qualcomm.com> writes:

> This fix the regerssion introduced after "ath10k_wmi_requests_stats()
> call to use more stat bits", both the 10.2.X FW and community FW 10.1.X
> will return time out when access the fw_stats with the STAT_VDEV and
> STAT_PDEV. Add the condition to use different fw_stats mask for different
> FW versions.
>
> Fixes:7777d8c7ef6f("ath10k: implement fw stats for wmi-tlv")
> Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
