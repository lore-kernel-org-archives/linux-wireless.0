Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26681 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbaAWM4c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 07:56:32 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: AP mode, set UAPSD params correctly
References: <1390284413-2703-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Thu, 23 Jan 2014 14:56:26 +0200
In-Reply-To: <1390284413-2703-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Tue, 21 Jan 2014 07:06:53 +0100")
Message-ID: <87k3dq501x.fsf@kamboji.qca.qualcomm.com> (sfid-20140123_135635_835520_26946F94)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> ath10k handles UAPSD completly in the firmware.
> When works in AP mode we have to configure
> UAPSD params for each station. Without this
> patch we configure UAPSD params before we
> send peer assoc command to the FW, which was
> wrong. Next FW didn't know what should be trigger
> frame, couse UAPSD didn't work correctly in AP mode.
> To configure UAPSD params correctly we have to
> send them after peer assoc command.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, applied.

-- 
Kalle Valo
