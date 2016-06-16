Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34573 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbcFPQGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 12:06:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Eduardo Abinader <eduardo.abinader@riverbed.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: return false when reading wrong eeprom offset
References: <57616B61.8020406@riverbed.com>
Date: Thu, 16 Jun 2016 19:06:28 +0300
In-Reply-To: <57616B61.8020406@riverbed.com> (Eduardo Abinader's message of
	"Wed, 15 Jun 2016 16:51:13 +0200")
Message-ID: <87twgtuni3.fsf@kamboji.qca.qualcomm.com> (sfid-20160616_180650_992767_1F83C31E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eduardo Abinader <eduardo.abinader@riverbed.com> writes:

> Just setting the proper return for reading beyond the
> eeprom data.
>
> Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>
> ---
>  drivers/net/wireless/ath/ath9k/pci.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/pci.c
> b/drivers/net/wireless/ath/ath9k/pci.c
> index 7cdaf40..aa04b13 100644

The patch is corrupted, most likely due to an extra newline. Please
resend.

Applying: ath9k: return false when reading wrong eeprom offset
fatal: corrupt patch at line 14
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 ath9k: return false when reading wrong eeprom offset

-- 
Kalle Valo
