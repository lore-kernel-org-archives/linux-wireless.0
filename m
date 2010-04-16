Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:46734 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab0DPFDO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 01:03:14 -0400
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wl1251: register platform_device to pass board data
References: <1271345003-15453-1-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Fri, 16 Apr 2010 08:03:12 +0300
In-Reply-To: <1271345003-15453-1-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Thu\, 15 Apr 2010 18\:23\:23 +0300")
Message-ID: <87iq7sm1kf.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> wl1251 is embedded chip that can be connected using SDIO bus, and is not
> an actual SDIO card. For this reason there is a need to pass some board
> specific data, like 'EEPROM is attached' flag or power control callback.
>
> However currently there is no way to pass this data through SDIO subsystem,
> so this patch registers dummy platform_device to allow that, until we
> have a better solution to this.

Looks very good now, thanks a lot for doing this.

> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
