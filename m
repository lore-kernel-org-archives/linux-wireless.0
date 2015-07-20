Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42257 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbbGTPnd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 11:43:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] rtlwifi: rtl8192c: Add init codes for "fw_version" and "fw_subversion".
References: <1434552997-3562-1-git-send-email-ap420073@gmail.com>
Date: Mon, 20 Jul 2015 18:43:28 +0300
In-Reply-To: <1434552997-3562-1-git-send-email-ap420073@gmail.com> (Taehee
	Yoo's message of "Wed, 17 Jun 2015 23:56:37 +0900")
Message-ID: <87bnf6sulb.fsf@kamboji.qca.qualcomm.com> (sfid-20150720_174337_095856_563F133C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taehee Yoo <ap420073@gmail.com> writes:

> The variable "fw_version" is used in the _ResetDigitalProcedure1().
> but It is not initialized. so I add init codes for "fw_version" and
> "fw_subversion".
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
> V3 - Fix sparse warning.
> V2 - Moved new statements into location where header is known to exist.

I have already applied v2 and v3 won't apply anymore. What you need to
do is to create a new patch against wireless-drivers-next (on top of v2)
which fixes the sparse warning.

-- 
Kalle Valo
