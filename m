Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:39558 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137Ab1KUPhj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 10:37:39 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com
Subject: Re: [PATCH] ath9k: Improve ath_tx_aggr_stop to avoid TID stuck in cleanup state.
References: <1321684883-6870-1-git-send-email-mar.kolya@gmail.com>
Date: Mon, 21 Nov 2011 17:37:34 +0200
In-Reply-To: <1321684883-6870-1-git-send-email-mar.kolya@gmail.com> (Nikolay
	Martynov's message of "Sat, 19 Nov 2011 01:41:23 -0500")
Message-ID: <87r511ij0h.fsf@purkki.adurom.net> (sfid-20111121_163747_117547_3D45946B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nikolay Martynov <mar.kolya@gmail.com> writes:

> From: kolya <mar.kolya@gmail.com>

Please use your full name here.

>   When tx agg is being stopped TID is flushed using ath_tx_flush_tid. It is possible that ath_tx_flush_tid completelly flushes TID (if all packets in this TID have already been retried). If this happened ath_tx_aggr_stop would leave TID in cleanup state permanently. Fix this by making ath_tx_flush_tid remove AGGR_ADDBA_COMPLETE and AGGR_CLEANUP flags from TID status if TID is empty.

And word wrap your commits to 72 chars or so.

-- 
Kalle Valo
