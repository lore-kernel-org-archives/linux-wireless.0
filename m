Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12401 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab1KUQVy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 11:21:54 -0500
Message-ID: <4ECA7A9B.3070501@qca.qualcomm.com> (sfid-20111121_172215_246231_67C80273)
Date: Mon, 21 Nov 2011 18:21:47 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Kevin Fang <chienf@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] ath6kl: unlock if ath6kl_cfg80211_connect() fails
References: <20111118140932.GB9685@elgon.mountain>
In-Reply-To: <20111118140932.GB9685@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2011 04:09 PM, Dan Carpenter wrote:
> There is an unlock missing on this error path.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied to ath6kl.git. There was a conflict but that was easy to
fix.

Kalle
