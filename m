Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:15928 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbcAGNA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 08:00:26 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Set SM power save disabled to default value
References: <1450478624-21881-1-git-send-email-poh@qca.qualcomm.com>
Date: Thu, 7 Jan 2016 14:59:22 +0200
In-Reply-To: <1450478624-21881-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Fri, 18 Dec 2015 14:43:44 -0800")
Message-ID: <87a8ohlf4l.fsf@kamboji.qca.qualcomm.com> (sfid-20160107_140029_382314_76D6E947)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> Use SMPS disabled as default because FW does not indicate
> any support of SMPS.
>
> This change will help STAs out that don’t support SMPS from
> sticking on 1SS, since they don’t have method to change it
> back to multiple chains.
>
> This change also should not affect power consumption of STAs
> supporting SMPS, because they are capable to switch the mode
> to dynamic or static either at the end of frame sequence or
> by using SMPS action frame.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo
