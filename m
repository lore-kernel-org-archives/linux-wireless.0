Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18390 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887AbbGPPCG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2015 11:02:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t6GExKkQ017311
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2015 08:02:05 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 1vnb4c5drm-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2015 08:02:04 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 0/3] mwifiex p2p fixes
Date: Thu, 16 Jul 2015 15:02:03 +0000
Message-ID: <a149ae7c7ab04ac489c5d7d8e230bd5b@SC-EXCH02.marvell.com> (sfid-20150716_170210_404262_7B625381)
References: <1437053249-18440-1-git-send-email-akarwar@marvell.com>
In-Reply-To: <1437053249-18440-1-git-send-email-akarwar@marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: Amitkumar Karwar [mailto:akarwar@marvell.com]
> Sent: Thursday, July 16, 2015 6:57 PM
> To: linux-wireless@vger.kernel.org
> Cc: Cathy Luo; Amitkumar Karwar
> Subject: [PATCH 0/3] mwifiex p2p fixes
> 
> This patch series resolves couple of issues observed during p2p
> opeations.
> 
> Aniket Nagarnaik (3):
>   UPSTREAM: mwifiex: add bss mode TLV to extended scan command
>   UPSTREAM: mwifiex: use maximum ssid length as 0xfe for p2p
>   UPSTREAM: mwifiex: correct p2p and station interface counters
> 
>  drivers/net/wireless/mwifiex/cfg80211.c |  4 +++-
>  drivers/net/wireless/mwifiex/fw.h       |  6 ++++++
>  drivers/net/wireless/mwifiex/scan.c     | 14 ++++++++++++++
>  3 files changed, 23 insertions(+), 1 deletion(-)
> 

Please ignore this patch series.
I will remove redundant tag "UPSTREAM:" and submit updated version.

Regards,
Amitkumar
