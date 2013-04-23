Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:50339 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757208Ab3DWShJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 14:37:09 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"daniel@zonque.org" <daniel@zonque.org>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>
Date: Tue, 23 Apr 2013 11:33:13 -0700
Subject: RE: [PATCH v3 0/2] wmm queues handling simplificatons
Message-ID: <477F20668A386D41ADCC57781B1F70430D9E057C14@SC-VEXCH1.marvell.com> (sfid-20130423_233111_724367_ECDF1C13)
References: <477F20668A386D41ADCC57781B1F70430D9DE96073@SC-VEXCH1.marvell.com>
 <1365681068-27820-1-git-send-email-andreas.fenkart@streamunlimited.com>
In-Reply-To: <1365681068-27820-1-git-send-email-andreas.fenkart@streamunlimited.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> 
> v3: minor cleanups for coding style; checkpatch.pl --strict

Could you please apply the v3 series from Andreas Fenkart?
I've ACKed both patches individually.

Thanks,
Bing

> v2: split 6 patches into 2 patchsets. This is the set 2.
> 
> Andreas Fenkart (2):
>   mwifiex: replace ra_list_curr by list rotation.
>   mwifiex: rework round robin scheduling of bss nodes.
> 
>  drivers/net/wireless/mwifiex/11n_aggr.c |   14 +--
>  drivers/net/wireless/mwifiex/init.c     |   21 ++--
>  drivers/net/wireless/mwifiex/main.h     |    1 -
>  drivers/net/wireless/mwifiex/wmm.c      |  160 ++++++++++---------------------
>  drivers/net/wireless/mwifiex/wmm.h      |    3 +
>  5 files changed, 61 insertions(+), 138 deletions(-)

