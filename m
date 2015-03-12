Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20442 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002AbbCLOHv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 10:07:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t2CE4Oet008640
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 07:07:50 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1t2q5a3h6e-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 07:07:50 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>
Date: Thu, 12 Mar 2015 07:07:49 -0700
Subject: RE: [PATCH] mwifiex: fix a bug in Rx multiport aggregation logic
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951B16A0745C@SC-VEXCH1.marvell.com> (sfid-20150312_150754_142367_93B07332)
References: <1426145920-5288-1-git-send-email-akarwar@marvell.com>
In-Reply-To: <1426145920-5288-1-git-send-email-akarwar@marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Amitkumar Karwar [mailto:akarwar@marvell.com]
> Sent: Thursday, March 12, 2015 1:09 PM
> To: linux-wireless@vger.kernel.org
> Cc: Cathy Luo; Avinash Patil; Amitkumar Karwar
> Subject: [PATCH] mwifiex: fix a bug in Rx multiport aggregation logic
> 
> From: Cathy Luo <cluo@marvell.com>
> 
> It's been observed Rx aggregated packets are always followed by a
> single Rx packet. This patch improves our logic to add that extra
> packet in next aggregation.
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---

Please ignore this patch. This is same as "[PATCH 1/3] mwifiex: fix 
a bug..." sent separately.

Regards,
Amit
