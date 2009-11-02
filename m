Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:62254 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbZKBRQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 12:16:33 -0500
Message-ID: <4AEF13E5.4090309@nokia.com>
Date: Mon, 02 Nov 2009 19:16:21 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: "ext Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wl1271: use __dev_alloc_skb() on RX
References: <1257182115-31723-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257182115-31723-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Luis R. Rodriguez wrote:
> RX is handled in a workqueue therefore allocating for GFP_ATOMIC
> is overkill and not required.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> Acked-by: Luciano Coelho <luciano.coelho@nokia.com>
> ---

Thank you very much, Luis!

-- 
Cheers,
Luca.
