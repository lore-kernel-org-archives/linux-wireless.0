Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:33081 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaCMFsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2014 01:48:53 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath6kl@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/6] ath6kl: fixing new checkpatch warnings
References: <20140309065606.10793.67068.stgit@x230>
Date: Thu, 13 Mar 2014 07:48:47 +0200
In-Reply-To: <20140309065606.10793.67068.stgit@x230> (Kalle Valo's message of
	"Sun, 09 Mar 2014 08:57:05 +0200")
Message-ID: <87ha72d4xs.fsf@kamboji.qca.qualcomm.com> (sfid-20140313_064917_697050_54BE5C1C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> this patchset fixes new checkpatch warnings which have appeared during the last
> year or so.
>
> ---
>
> Kalle Valo (6):
>       ath6kl: fix blank lines before and after braces
>       ath6kl: use braces on both arms of if statement
>       ath6kl: remove spaces before semicolon
>       ath6kl: remove unnecessary line continuations
>       ath6kl: update Kconfig descriptions

These five patches applied.

>       ath6kl: remove a warning on a macro

This patch dropped for now. Need to find a better solution.

-- 
Kalle Valo
