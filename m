Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:4398 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbbI0MuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2015 08:50:22 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath: fix incorrect PPB on JAPAN chirp radar
References: <1441819724-25344-1-git-send-email-poh@qca.qualcomm.com>
Date: Sun, 27 Sep 2015 15:50:09 +0300
In-Reply-To: <1441819724-25344-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Wed, 9 Sep 2015 10:28:44 -0700")
Message-ID: <87oagoc9ha.fsf@kamboji.qca.qualcomm.com> (sfid-20150927_145046_213173_BD226429)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> The number of pulses per burst on Japan chirp radar is
> between 1 and 3. The previous value, 20, is representing
> number of bursts, but since current DFS detector is using
> pulse detection other than bursts, use the pulse number
> for correct radar detection.
> Also using the highest number helps to avoid false detection.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
