Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:15907 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755663AbaHVGet convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 02:34:49 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Cathy Luo <cluo@marvell.com>
Date: Thu, 21 Aug 2014 23:34:39 -0700
Subject: RE: [PATCH 1/3] mwifiex: fix left_len calculation issue
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF595181989DDB7@SC-VEXCH1.marvell.com> (sfid-20140822_083452_872025_6A0B6D25)
References: <1408451758-22463-1-git-send-email-akarwar@marvell.com>
In-Reply-To: <1408451758-22463-1-git-send-email-akarwar@marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> -----Original Message-----
> From: Amitkumar Karwar [mailto:akarwar@marvell.com]
> Sent: 19 August 2014 18:06
> To: linux-wireless@vger.kernel.org
> Cc: linville@tuxdriver.com; Amitkumar Karwar; Avinash Patil; Cathy Luo
> Subject: [PATCH 1/3] mwifiex: fix left_len calculation issue
> 
> While updating 'left_len' in each iteration, we should subtract last
> TLV length not the accumulated length of TLVs parsed till now.
> This bug in parsing logic is exposed by newer firmware which adds two
> TLVs in GET_HW_SPEC command response. Earlier firmwares used to add
> only one TLV.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/cmdevt.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Somehow I don't see these patches on the list. Should I resend them?

Thanks,
Amitkumar Karwar
