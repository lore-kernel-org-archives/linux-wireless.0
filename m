Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:51752 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab0LRJu4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 04:50:56 -0500
To: Dan Carpenter <error27@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] wl1251: wl12xx_get_platform_data() returns an ERR_PTR
References: <20101218085210.GO1639@bicker>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 18 Dec 2010 11:12:10 +0200
In-Reply-To: <20101218085210.GO1639@bicker> (Dan Carpenter's message of "Sat\, 18 Dec 2010 11\:52\:10 +0300")
Message-ID: <8762urigwl.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <error27@gmail.com> writes:

> wl12xx_get_platform_data() returns an ERR_PTR on failure and it never
> returns a NULL.

Yes, that's true. Good that you found this.

> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
