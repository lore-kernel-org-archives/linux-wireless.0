Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:54673 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab0KGKPd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Nov 2010 05:15:33 -0500
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/3] wl1251: add power callback to wl1251_if_operations
References: <1288822429-24541-1-git-send-email-notasas@gmail.com>
	<1288822429-24541-2-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 07 Nov 2010 12:15:31 +0200
In-Reply-To: <1288822429-24541-2-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Thu\,  4 Nov 2010 00\:13\:47 +0200")
Message-ID: <87hbftzbgc.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> Call interface specific power callback before calling board specific
> one. Also allow that callback to fail. This is how it's done for
> wl1271 and will be used for runtime_pm support.

Thanks, looks good to me.

> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
