Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:35568 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934010AbbJIIhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 04:37:48 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vivek Natarajan <nataraja@qti.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v3] ath10k: Use station's current operating mode from assoc request
References: <1444060928-5702-1-git-send-email-nataraja@qti.qualcomm.com>
Date: Fri, 9 Oct 2015 11:37:36 +0300
In-Reply-To: <1444060928-5702-1-git-send-email-nataraja@qti.qualcomm.com>
	(Vivek Natarajan's message of "Mon, 5 Oct 2015 21:32:08 +0530")
Message-ID: <87d1wosai7.fsf@kamboji.qca.qualcomm.com> (sfid-20151009_103753_030745_F5A909A9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <nataraja@qti.qualcomm.com> writes:

> The current number of spatial streams used by the client is advertised
> as a separate IE in assoc request. Use this information to set
> the NSS operating mode.
>
> Fixes: 45c9abc059fa ("ath10k: implement more versatile set_bitrate_mask").
> Signed-off-by: Vivek Natarajan <nataraja@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo
