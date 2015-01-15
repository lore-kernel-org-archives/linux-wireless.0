Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:59005 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbbAOMr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 07:47:59 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	thomas@net.t-labs.tu-berlin.de, adrian@freebsd.org
Subject: Re: [PATCH 0/3] add TPC capability for AR9002 based chips
References: <1419977420-23732-1-git-send-email-lorenzo.bianconi83@gmail.com>
Date: Thu, 15 Jan 2015 14:47:51 +0200
In-Reply-To: <1419977420-23732-1-git-send-email-lorenzo.bianconi83@gmail.com>
	(Lorenzo Bianconi's message of "Tue, 30 Dec 2014 23:10:17 +0100")
Message-ID: <87bnm0tdl4.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_134802_166463_9B360CD1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi83@gmail.com> writes:

> This patchset adds TPC capability to ath9k for AR9002 based chips
>
> *[PATCH 1/3]: add TX power per-rate tables to cap TX power in TX descriptor path
> *[PATCH 2/3]: cap per-packet TX power according to TX power per-rate tables
> *[PATCH 3/3]: enable per-packet TPC on AR9002 based chips by default
>
> This pachset is based on Adrian Chadd's hints
> (https://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg10396.html)
>
> Changes since RFC:
> - fix compilation error
>
> Lorenzo Bianconi (3):
>   ath9k: add power per-rate tables for AR9002 chips
>   ath9k: add TPC to TX path for AR9002 based chips
>   ath9k: enable per-packet TPC on AR9002 based chips

Thanks, applied to wireless-drivers-next.git

-- 
Kalle Valo
