Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37182 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbbFHGQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 02:16:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Xavier Roche <roche@httrack.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Trivial Patch Monkey <trivial@kernel.org>
Subject: Re: [PATCH] rtl8723au: replaced asm/atomic.h by linux/atomic.h
References: <1432791571-17262-1-git-send-email-roche@httrack.com>
Date: Mon, 08 Jun 2015 09:16:08 +0300
In-Reply-To: <1432791571-17262-1-git-send-email-roche@httrack.com> (Xavier
	Roche's message of "Thu, 28 May 2015 07:39:31 +0200")
Message-ID: <87oakqlo7r.fsf@kamboji.qca.qualcomm.com> (sfid-20150608_081633_059286_02EAF9F5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xavier Roche <roche@httrack.com> writes:

> Minor additional checkpatch.pl fix for include/rtw_io.h
>
> Signed-off-by: Xavier Roche <roche@httrack.com>
> ---
>  drivers/staging/rtl8723au/include/rtw_io.h | 2 +-

For staging patches please prefix the title "staging: " so that people
will realise that this a patch for a driver in staging. So this should
be renamed to "staging: rtl8723au: replaced asm/atomic.h by
linux/atomic.h".

Here's a tip how you can check what commit title you should use:

git log --oneline drivers/staging/rtl8723au/include/rtw_io.h

-- 
Kalle Valo
