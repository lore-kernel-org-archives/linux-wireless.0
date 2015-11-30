Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:3676 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbbK3ItL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 03:49:11 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Brent Taylor <motobud@gmail.com>
CC: <netdev@vger.kernel.org>, <ath6kl@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] ath6kl: Use vmalloc for loading firmware using api1 method and use kvfree
References: <1448774038-26984-1-git-send-email-motobud@gmail.com>
	<1448776283-28383-1-git-send-email-motobud@gmail.com>
Date: Mon, 30 Nov 2015 10:48:57 +0200
In-Reply-To: <1448776283-28383-1-git-send-email-motobud@gmail.com> (Brent
	Taylor's message of "Sat, 28 Nov 2015 23:51:23 -0600")
Message-ID: <87vb8jlvnq.fsf@kamboji.qca.qualcomm.com> (sfid-20151130_094957_663782_929F113B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brent Taylor <motobud@gmail.com> writes:

> Signed-off-by: Brent Taylor <motobud@gmail.com>
>
> ath6kl: Use vmalloc for loading firmware using api1 method and free using kvfree
>
> ath6kl: fix kmalloc build error
> ---
> Changes v2 -> v3:
>    - fix kmalloc build error
>
> Changes v1 -> v2:
>    - simplify memory allocation
>    - use kvfree

The commit log in v3 is even worse.

-- 
Kalle Valo
