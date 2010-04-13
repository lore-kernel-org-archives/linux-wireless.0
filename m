Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:41053 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab0DMRHf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 13:07:35 -0400
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl1251: don't require NVS data when EEPROM is used
References: <1271110900-18572-1-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 13 Apr 2010 20:07:33 +0300
In-Reply-To: <1271110900-18572-1-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Tue\, 13 Apr 2010 01\:21\:40 +0300")
Message-ID: <87bpdnnuwa.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> If EEPROM is used, NVS data is now loaded but ignored.
> Stop loading it to avoid need of dummy NVS file for modules with EEPROM.
>
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

Thanks a lot for the patch.

-- 
Kalle Valo
