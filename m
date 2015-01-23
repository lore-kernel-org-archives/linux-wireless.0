Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:35417 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbbAWRMr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 12:12:47 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/8] wcn36xx: initialize device defaults on start
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1420830952-9624-2-git-send-email-me@bobcopeland.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
Message-Id: <20150123171246.81A2B1414A1@smtp.codeaurora.org> (sfid-20150123_181254_492477_791B392F)
Date: Fri, 23 Jan 2015 17:12:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Set up default configuration for the device when we call start.
> The defaults come from dumps from the prima driver for the same
> hardware.
> 
> This fixes transmit A-MPDU; previously only one MPDU would be
> sent per A-MPDU due to missing MAX_MPDUS_IN_AMPDU setting.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Thanks, 8 patches applied to wireless-drivers-next.git:

69a88cc7b164 wcn36xx: initialize device defaults on start
f786a6d4af92 wcn36xx: use !! when assigning int as a boolean
232ddcd80fa5 wcn36xx: let device generate qos seq numbers
bfa6696b39ae wcn36xx: don't process 'valid' descriptors
90dccb73e985 wcn36xx: initialize skb_lock
4b12462a3a7f wcn36xx: initialize dxe lock
5f3f928585b2 wcn36xx: move set_tx_pdu inside set_tx_data/mgmt
e26dc173a66a wcn36xx: initiate TX BA sessions

Kalle Valo
