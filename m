Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42934 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab3FEPQT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 11:16:19 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Antonio Quartulli <ordex@autistici.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>,
	Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	<ath6kl-devel@qca.qualcomm.com>
Subject: Re: [PATCHv4 3/4] ath6kl: make mgmt_tx accept a NULL channel
References: <1370444989-2095-1-git-send-email-ordex@autistici.org>
	<1370444989-2095-3-git-send-email-ordex@autistici.org>
Date: Wed, 5 Jun 2013 18:16:12 +0300
In-Reply-To: <1370444989-2095-3-git-send-email-ordex@autistici.org> (Antonio
	Quartulli's message of "Wed, 5 Jun 2013 17:09:48 +0200")
Message-ID: <87ip1sy4eb.fsf@kamboji.qca.qualcomm.com> (sfid-20130605_171622_375662_4183E472)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antonio Quartulli <ordex@autistici.org> writes:

> From: Antonio Quartulli <antonio@open-mesh.com>
>
> cfg80211 passes a NULL channel to mgmt_tx if the frame has
> to be sent on the one currently in use by the device.
> Make the implementation of mgmt_tx correctly handle this
> case
>
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Cc: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>

Thanks.

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo
