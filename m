Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:22872 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaCUPht (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 11:37:49 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: add ath10k_htt_rx_amsdu_allowed function
In-Reply-To: <1395209381-26782-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Wed, 19 Mar 2014 07:09:40 +0100")
References: <1395209381-26782-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Fri, 21 Mar 2014 17:37:44 +0200
Message-ID: <8738ibbm0n.fsf@kamboji.qca.qualcomm.com> (sfid-20140321_163753_488807_C4EC091F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Introduce ath10k_htt_rx_amsdu_allowed() function, that
> group code for checking if skip amsdu packets.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, both patches applied.

-- 
Kalle Valo
