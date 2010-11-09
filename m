Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58301 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab0KIOMy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 09:12:54 -0500
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCHv2 2/3] wl1251: add runtime PM support for SDIO
References: <1289222976-19793-1-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 09 Nov 2010 16:12:51 +0200
In-Reply-To: <1289222976-19793-1-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Mon\,  8 Nov 2010 15\:29\:36 +0200")
Message-ID: <87sjzay49o.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> Add runtime PM support, similar to how it's done for wl1271.
> This allows to power down the card when the driver is loaded but
> network is not in use.

Looks good. Thanks again for improving wl1251.

> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
