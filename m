Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34206 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab1JFIzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 04:55:44 -0400
Message-ID: <4E8D6CFF.8090701@qca.qualcomm.com> (sfid-20111006_105547_391580_E2DB09F5)
Date: Thu, 6 Oct 2011 11:55:27 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	"Ng, Chilam" <chilamng@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: make sure WLAN power save is enabled during suspend
References: <20111005071252.19388.38625.stgit@localhost6.localdomain6>
In-Reply-To: <20111005071252.19388.38625.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/05/2011 10:12 AM, Kalle Valo wrote:
> From: Chilam Ng <chilamng@qca.qualcomm.com>
> 
> Power save is enabled during ath6kl init. But when user space disables power
> save, the system will go into suspend with power save disabled. The ath6kl
> driver will now explicitly enable power save prior to entering suspend and
> restore its previous setting upon resume

Applied.

Kalle
