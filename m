Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14397 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbbAFKPo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 05:15:44 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t06AFYWE007418
	for <linux-wireless@vger.kernel.org>; Tue, 6 Jan 2015 02:15:43 -0800
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1rqrtjkdek-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2015 02:15:43 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Maithili Hinge <maithili@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>
Date: Tue, 6 Jan 2015 02:15:41 -0800
Subject: RE: [PATCH 0/9] mwifiex enhancements
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951B16179343@SC-VEXCH1.marvell.com> (sfid-20150106_111550_243560_3CE2F4DD)
References: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
In-Reply-To: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

>-----Original Message-----
>From: Amitkumar Karwar [mailto:akarwar@marvell.com]
>Sent: 31 December 2014 16:07
>To: linville@tuxdriver.com
>Cc: linux-wireless@vger.kernel.org; Maithili Hinge; Avinash Patil; Cathy
>Luo; Marc Yang; Amitkumar Karwar
>Subject: [PATCH 0/9] mwifiex enhancements
>
>This patch series adds couple of fixes, recovery mechanism when host
>fails to wakeup the firmware and wowlan disconnect feature.
>
>Amitkumar Karwar (5):
>  mwifiex: remove redundant flag MWIFIEX_HW_STATUS_FW_READY
>  mwifiex: add wakeup timer based recovery mechanism
>  mwifiex: wakeup pending wait queues
>  mwifiex: do not release lock during list_for_each_entry_safe()
>  mwifiex: Increase priority of firmware download message
>
>Maithili Hinge (2):
>  mwifiex: Move code for wowlan magic-packet and patterns to a function
>  mwifiex: Add support for wowlan disconnect
>
>Marc Yang (2):
>  Adjust calling place of mwifiex_terminate_workqueue
>  mwifiex: increase delay during card reset
>
> drivers/net/wireless/mwifiex/cfg80211.c  | 95 +++++++++++++++++++++----
>-------
> drivers/net/wireless/mwifiex/cmdevt.c    |  6 --
> drivers/net/wireless/mwifiex/init.c      | 18 ++++++
> drivers/net/wireless/mwifiex/main.c      | 12 ++--
> drivers/net/wireless/mwifiex/main.h      |  2 +-
> drivers/net/wireless/mwifiex/pcie.c      |  5 +-
> drivers/net/wireless/mwifiex/sdio.c      |  8 +--
> drivers/net/wireless/mwifiex/sta_event.c |  3 +
> drivers/net/wireless/mwifiex/usb.c       |  4 +-
> 9 files changed, 101 insertions(+), 52 deletions(-)
>
>--
>1.8.1.4

Could you please check this patch series? Let me know if you want me to resend.

Best regards,
Amitkumar
