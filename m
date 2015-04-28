Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54872 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030247AbbD1QVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 12:21:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Taehee Yoo <ap420073@gmail.com>, Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Fix some beacon issue
References: <1424443813-13634-1-git-send-email-ap420073@gmail.com>
Date: Tue, 28 Apr 2015 19:21:11 +0300
In-Reply-To: <1424443813-13634-1-git-send-email-ap420073@gmail.com> (Taehee
	Yoo's message of "Fri, 20 Feb 2015 23:50:13 +0900")
Message-ID: <87383k5img.fsf@kamboji.qca.qualcomm.com> (sfid-20150428_182122_668192_CB1215C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taehee Yoo <ap420073@gmail.com> writes:

> Sometimes rtl8192cu is not sending beacon frame.
> This patch fix this issue.
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Larry, what do you think? Should I apply this?

https://patchwork.kernel.org/patch/5856761/

-- 
Kalle Valo
