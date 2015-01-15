Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:58316 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbbAOMj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 07:39:57 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath: ath9k: use debugfs_create_devm_seqfile() helper for seq_file entries
References: <1419685980-4728-1-git-send-email-arend@broadcom.com>
Date: Thu, 15 Jan 2015 14:39:50 +0200
In-Reply-To: <1419685980-4728-1-git-send-email-arend@broadcom.com> (Arend van
	Spriel's message of "Sat, 27 Dec 2014 14:13:00 +0100")
Message-ID: <87oaq0tdyh.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_134000_813889_3DF97531)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> Use the helper to get rid of the file operations per debugfs file. The
> device driver data contains struct ieee80211_hw pointer and the
> struct ath9k_softc pointer is assigned to ieee80211_hw::priv so it can
> be accessed in the seq_file read operation.
>
> Cc: ath9k-devel@lists.ath9k.org
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, applied to wireless-drivers-next.git.

-- 
Kalle Valo
