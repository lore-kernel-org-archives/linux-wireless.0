Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:59132 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab1DDSSG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 14:18:06 -0400
To: Jarkko Nikula <jhnikula@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] wl1251: Add support for idle mode
References: <1301904298-4725-1-git-send-email-jhnikula@gmail.com>
	<1301904298-4725-2-git-send-email-jhnikula@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 04 Apr 2011 21:18:01 +0300
In-Reply-To: <1301904298-4725-2-git-send-email-jhnikula@gmail.com> (Jarkko Nikula's message of "Mon\,  4 Apr 2011 11\:04\:58 +0300")
Message-ID: <87oc4lricm.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jarkko Nikula <jhnikula@gmail.com> writes:

> On Nokia N900 the wl1251 consumes the most power when the interface is up
> but not associated to access point (that supports PSM). In terms of battery
> current consumption, the consumption is ~180 mA higher when the interface is
> up but not associated and only ~5 mA higher when associated compared to
> interface down and driver not loaded cases.

Still looking good. You are going to make a lot of meego people happy
with this patch. :)

> Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
