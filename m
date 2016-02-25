Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54533 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbcBYJhB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 04:37:01 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 03/28] rtl8xxxu: If fw running in RAM, reset the 8051 before trying to download a new one
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
	<1454524802-26763-4-git-send-email-Jes.Sorensen@redhat.com>
Date: Thu, 25 Feb 2016 11:36:54 +0200
In-Reply-To: <1454524802-26763-4-git-send-email-Jes.Sorensen@redhat.com> (Jes
	Sorensen's message of "Wed, 3 Feb 2016 13:39:37 -0500")
Message-ID: <87a8mpf7wp.fsf@kamboji.qca.qualcomm.com> (sfid-20160225_103708_335613_53D1234E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes.Sorensen@redhat.com writes:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

No empty commit logs, please. And this patch even has a too long title
which really should be the actual commit log.

I can take this now but in the future please write one.

-- 
Kalle Valo
