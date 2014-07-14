Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62000 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbaGNMsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 08:48:46 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: add implementation for configure max amsdu, ampdu
References: <1401438255-7349-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Mon, 14 Jul 2014 15:48:40 +0300
In-Reply-To: <1401438255-7349-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Fri, 30 May 2014 10:24:15 +0200")
Message-ID: <87lhrwm7h3.fsf@kamboji.qca.qualcomm.com> (sfid-20140714_144849_572514_1114C823)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Allow to setup maximum subframes for AMSDU and AMPDU aggregation
> via debugfs htt_max_amsdu_ampdu file.
>
> Eg.
> echo "2 64" > htt_max_amsdu_ampdu
> will setup maximum amsdu subframes equal 2 and
> maximum ampdu subframes equal to 64.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, applied.

-- 
Kalle Valo
