Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63066 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2ARMLG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 07:11:06 -0500
Message-ID: <4F16B682.60302@qca.qualcomm.com> (sfid-20120118_131110_847513_1EA392AE)
Date: Wed, 18 Jan 2012 14:09:38 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v3 1/8] ath6kl: rename vif init and cleanup functions
References: <20120117180827.29995.67922.stgit@localhost6.localdomain6>
In-Reply-To: <20120117180827.29995.67922.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/17/2012 08:08 PM, Kalle Valo wrote:
> ath6kl_cfg80211_vif_init/cleanup() follow more closely the style used
> elsewhere in ath6kl.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

All eight patches applied to ath6kl.git master branch.

Now the reverted USB code is back and I will send a merge request to
John as soon as he opens his tree. At least this time we should have
plenty of time to sort out any build issues and no holiday season in
sight :)

Kalle
