Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56611 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbcDOSZN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 14:25:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Byeoungwook Kim <quddnr145@gmail.com>
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] rtlwifi: Fix reusable codes in core.c
References: <20160203020139.GA13619@gmail.com>
Date: Fri, 15 Apr 2016 21:25:05 +0300
In-Reply-To: <20160203020139.GA13619@gmail.com> (Byeoungwook Kim's message of
	"Wed, 3 Feb 2016 11:01:39 +0900")
Message-ID: <87bn5apw5a.fsf@kamboji.qca.qualcomm.com> (sfid-20160415_202538_161806_D09ED732)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Byeoungwook Kim <quddnr145@gmail.com> writes:

> rtl_*_delay() functions were reused same codes about addr variable.
> So i have converted to rtl_addr_delay() from code about addr variable.
>
> Signed-off-by: Byeoungwook Kim <quddnr145@gmail.com>
> Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Doesn't apply:

Applying: rtlwifi: Fix reusable codes in core.c
fatal: sha1 information is lacking or useless (drivers/net/wireless/realtek/rtlwifi/core.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 rtlwifi: Fix reusable codes in core.c

Please rebase and resend.

-- 
Kalle Valo
