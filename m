Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:8674 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933789AbbDIL41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2015 07:56:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: disable burst mode
References: <1427271291-31683-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Thu, 9 Apr 2015 14:56:19 +0300
In-Reply-To: <1427271291-31683-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Wed, 25 Mar 2015 09:14:51 +0100")
Message-ID: <87d23dfrbw.fsf@kamboji.qca.qualcomm.com> (sfid-20150409_135636_578117_7D43647B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Firmwares that indicate BURST_SERVICE as enabled
> could overwrite some wmm parameters (eg. txop).
> This could lead IOT and balancing issues.
> Hence disable this by default.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, applied.

-- 
Kalle Valo
