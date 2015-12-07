Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41672 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbbLGSEB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2015 13:04:01 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: linux-kernel@vger.kernel.org, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Fixing full name in patchwork
References: <1448281922-20382-1-git-send-email-sudipm.mukherjee@gmail.com>
Date: Mon, 07 Dec 2015 20:03:54 +0200
In-Reply-To: <1448281922-20382-1-git-send-email-sudipm.mukherjee@gmail.com>
	(Sudip Mukherjee's message of "Mon, 23 Nov 2015 18:02:02 +0530")
Message-ID: <87zixmb0fp.fsf@kamboji.qca.qualcomm.com> (sfid-20151207_190426_719086_5650B367)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sudip,

Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:

> We were dereferencing cmd first and checking for NULL later. Lets first
> check for NULL.
>
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

I noticed that your name in git log is not your full name:

commit 0a38c8e1b592c16d959da456f425053e323a5153
Author: sudip <sudipm.mukherjee@gmail.com>
Date:   Tue Nov 24 13:51:38 2015 +0530

This is because for some reason in patchwork your fullname is just
"sudip":

https://patchwork.kernel.org/patch/7688171/

Could you please fix your name in patchwork so that in the future we can
use your correct full name? The problem is that I don't know exactly how
to do this but it should be possible because I remember someone else
having a similar problem and he was able to fix it.

-- 
Kalle Valo
