Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57528 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbbK3PIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 10:08:05 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3] ath10k: introduce Mesh support in native WiFi mode for QCA988X
References: <1448386655-13936-1-git-send-email-poh@qca.qualcomm.com>
Date: Mon, 30 Nov 2015 17:07:52 +0200
In-Reply-To: <1448386655-13936-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Tue, 24 Nov 2015 09:37:32 -0800")
Message-ID: <87lh9fikzb.fsf@kamboji.qca.qualcomm.com> (sfid-20151130_160809_528315_D4D2782D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> QCA988X firmware has started supporting Mesh frame in native Wi-Fi mode
> by adding its subtype since 10.2.4.70.12-2.
> Hence update its WMI service map and vdev subtypes to be used for Mesh in
> native Wi-Fi mode.
>
> Peter Oh (3):
>   ath10k: update WMI 10.x service map
>   ath10k: introduce new subtypes for proxy STA and Mesh
>   ath10k: apply Mesh subtype when Mesh interface created.

All three applied, thanks.

-- 
Kalle Valo
