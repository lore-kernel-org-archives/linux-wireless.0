Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:34579 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab1DATae (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 15:30:34 -0400
To: Jarkko Nikula <jhnikula@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] wl1251: Add support for idle mode
References: <1301576643-29224-1-git-send-email-jhnikula@gmail.com>
	<1301576643-29224-2-git-send-email-jhnikula@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Fri, 01 Apr 2011 22:30:32 +0300
In-Reply-To: <1301576643-29224-2-git-send-email-jhnikula@gmail.com> (Jarkko Nikula's message of "Thu\, 31 Mar 2011 16\:04\:03 +0300")
Message-ID: <8762qxsraf.fsf@purkki.adurom.net>
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

Looks very good, thanks a lot for working on this.

> Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
