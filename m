Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32336 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab1HQQcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 12:32:36 -0400
Message-ID: <4E4BED24.5000501@qca.qualcomm.com> (sfid-20110817_183251_050707_EA79A256)
Date: Wed, 17 Aug 2011 09:32:36 -0700
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2] ath6kl: Fix bug in computing AMSU subframe padding
References: <1313473778-1740-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1313473778-1740-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/15/2011 10:49 PM, Vasanthakumar Thiagarajan wrote:
> This fixes AMSDU rx, otherwise it fails with the following warnings.
> 
> "802.3 AMSDU frame bound check failed"

Thanks, applied.

Kalle
