Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:52614 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab0DOFKd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 01:10:33 -0400
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wl1251: read default MAC address from EEPROM when available
References: <1271239548-15326-1-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 15 Apr 2010 08:10:30 +0300
In-Reply-To: <1271239548-15326-1-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Wed\, 14 Apr 2010 13\:05\:48 +0300")
Message-ID: <87tyrdmhbt.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> Some wl1251 hardware configurations (like in WG7210 module) have
> EEPROM attached where NVS data is kept, which includes MAC address.
>
> In such configurations, let's read default MAC address from EEPROM,
> instead of using random one.
>
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

Thank you for the patch.

-- 
Kalle Valo
