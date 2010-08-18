Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58946 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807Ab0HRPP7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 11:15:59 -0400
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/4] wl1251: fix beacon filter table structure
References: <1282074415-6168-1-git-send-email-notasas@gmail.com>
	<1282074415-6168-4-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 18 Aug 2010 18:15:57 +0300
In-Reply-To: <1282074415-6168-4-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Tue\, 17 Aug 2010 22\:46\:54 +0300")
Message-ID: <871v9w9ck2.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> The beacon filter table configuration ACX structure had certain elements
> reversed, fix it to match TI driver.
>
> Based on wl1271 patch 1937e742639c03a6fe77239c3003ce9602302117 by
> Juuso Oikarinen.

Yes, the padding doesn't make any sense otherwise.

> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
