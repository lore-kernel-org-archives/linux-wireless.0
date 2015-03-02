Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34344 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbbCBPO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 10:14:28 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 21/32] wireless: use %*pb[l] to print bitmaps including cpumasks and nodemasks
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
	<1422108218-25398-22-git-send-email-tj@kernel.org>
Date: Mon, 02 Mar 2015 17:14:22 +0200
In-Reply-To: <1422108218-25398-22-git-send-email-tj@kernel.org> (Tejun Heo's
	message of "Sat, 24 Jan 2015 09:03:27 -0500")
Message-ID: <87zj7va0tt.fsf@kamboji.qca.qualcomm.com> (sfid-20150302_161445_366436_F513C45C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tejun Heo <tj@kernel.org> writes:

> printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
> and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
> respectively which can be used to generate the two printf arguments
> necessary to format the specified cpu/nodemask.
>
> This patch is dependent on the following two patches.
>
>  lib/vsprintf: implement bitmap printing through '%*pb[l]'
>  cpumask, nodemask: implement cpumask/nodemask_pr_args()
>
> Please wait till the forementioned patches are merged to mainline
> before applying to subsystem trees.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: linux-wireless@vger.kernel.org

This was already applied so I'm dropping it from my queue.

-- 
Kalle Valo
