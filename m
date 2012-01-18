Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35191 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab2ARLrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 06:47:06 -0500
Message-ID: <4F16B09C.90304@qca.qualcomm.com> (sfid-20120118_124711_601387_5EA5B7BB)
Date: Wed, 18 Jan 2012 13:44:28 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath6kl: use netdev_features_t
References: <20120117130519.22832.29908.stgit@localhost6.localdomain6>
In-Reply-To: <20120117130519.22832.29908.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/17/2012 03:05 PM, Kalle Valo wrote:
> Commit c8f44affb7 ("net: introduce and use netdev_features_t for
> device features sets") added netdev_features_t to ndo_set_features.
> Change ath6kl to use the new type.
> 
> This fixes a warning:
> 
> ath6kl/main.c:1170: warning: initialization from incompatible pointer type
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

All three applied.

Kalle
