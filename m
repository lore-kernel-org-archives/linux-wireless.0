Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:16843 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab3GOICx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 04:02:53 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k@lists.infradead.org>
Subject: Re: [PATCH 00/16] ath10k: pending patches
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Date: Mon, 15 Jul 2013 11:02:45 +0300
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com> (Kalle
	Valo's message of "Fri, 5 Jul 2013 16:15:01 +0300")
Message-ID: <87a9lop7x6.fsf@kamboji.qca.qualcomm.com> (sfid-20130715_100310_059633_D69D7DEC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> here are pending patches which were commited to ath10k.git while
> ath10k was under review. They were only sent to ath9k-devel, I'm
> resending them now before I reapply them to my new ath.git tree.
>
> Michal Kazior (16):
>   ath10k: fix teardown ordering
>   ath10k: fix possible deadlock
>   ath10k: setup rts/frag thresholds upon vdev creation
>   ath10k: do not setup rts/frag thresholds for suspended interfaces
>   ath10k: remove ath10k_bus
>   ath10k: fix typo in define name
>   ath10k: silent warning in IBSS mode
>   ath10k: lower print level for a message
>   ath10k: provide errno if bmi read/write fails
>   ath10k: change function to take struct ath10k as arg
>   ath10k: rename hif callback
>   ath10k: embed HTC struct inside ath10k
>   ath10k: embed HTT struct inside ath10k
>   ath10k: improve locking
>   ath10k: abort scan properly if wmi_scan_stop fails
>   ath10k: add missing debug prints

All 16 applied.

-- 
Kalle Valo
