Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757532AbcAKMPe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2016 07:15:34 -0500
Date: Mon, 11 Jan 2016 13:13:39 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwl4965: Fix a memory leak in error handling code of
 __il4965_up
Message-ID: <20160111121339.GE25015@redhat.com> (sfid-20160111_131552_590498_07C64C8D)
References: <1452169059-20617-1-git-send-email-baijiaju1990@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1452169059-20617-1-git-send-email-baijiaju1990@163.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 07, 2016 at 08:17:39PM +0800, Jia-Ju Bai wrote:
> When il4965_hw_nic_init in __il4965_up fails, the memory allocated by 
> iwl4965_sta_alloc_lq in iwl4965_alloc_bcast_station is not freed.
> 
> This patches adds il_dealloc_bcast_stations in the error handling code of 
> __il4965_up to fix this problem.
> 
> This patch has been tested in real device, and it actually fixes the bug.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
