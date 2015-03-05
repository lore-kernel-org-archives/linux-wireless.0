Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:38067 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbbCEN4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 08:56:31 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath: Introduce chirp parameter used by DFS
References: <1423775825-19498-1-git-send-email-poh@qca.qualcomm.com>
Date: Thu, 5 Mar 2015 15:56:20 +0200
In-Reply-To: <1423775825-19498-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Thu, 12 Feb 2015 13:17:03 -0800")
Message-ID: <87k2yv4kfv.fsf@kamboji.qca.qualcomm.com> (sfid-20150305_145634_344914_02B3499F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> Some of radar types such as FCC radar type 5 require
> to look up chirp in pulse to detect genuine radar and
> it will prevent DFS channels from false radar detection.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Thanks, all three patches applied.

-- 
Kalle Valo
