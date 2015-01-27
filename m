Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:13031 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbbA0OWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 09:22:23 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: implement uapsd autotrigger command
References: <1421749497-10553-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 27 Jan 2015 16:22:12 +0200
In-Reply-To: <1421749497-10553-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 20 Jan 2015 11:24:56 +0100")
Message-ID: <87egqgb8x7.fsf@kamboji.qca.qualcomm.com> (sfid-20150127_152227_097867_40FFF898)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> New wmi-tlv firmware for qca6174 has u-UAPSD
> autotrigger service. If it is enabled firmware
> generates trigger frames automatically as
> configured.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
