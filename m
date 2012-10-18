Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3070 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab2JRSca (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 14:32:30 -0400
Message-ID: <50804B35.5080907@broadcom.com> (sfid-20121018_203234_561004_70404CE8)
Date: Thu, 18 Oct 2012 11:32:21 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Yuanhan Liu" <yuanhan.liu@linux.intel.com>
cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	fengguang.wu@intel.com, "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] brcmfmac: fix potential NULL dereference
References: <1350555056-17775-1-git-send-email-yuanhan.liu@linux.intel.com>
In-Reply-To: <1350555056-17775-1-git-send-email-yuanhan.liu@linux.intel.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18/2012 03:10 AM, Yuanhan Liu wrote:
> Fix a samtch warnings catched by Fengguang's 0-DAY system:
> + drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:3572 brcmf_cfg80211_sched_scan_start() error: we previously assumed 'request' could be null (see line 3571)
>
> Cc: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> ---

Thanks

Acked-by: Franky Lin <frankyl@broadcom.com>

Franky


