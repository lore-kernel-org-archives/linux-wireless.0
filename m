Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:59546 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab0KKMNd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 07:13:33 -0500
Subject: Re: [PATCH v5] wl1271: Change wl12xx Files Names
From: Luciano Coelho <luciano.coelho@nokia.com>
To: Shahar Levi <shahar_levi@ti.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1289215210-5276-1-git-send-email-shahar_levi@ti.com>
References: <1289215210-5276-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 14:13:28 +0200
Message-ID: <1289477608.1606.43.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-08 at 12:20 +0100, ext Shahar Levi wrote:
> All files name prefix removed due to the fact that wl12xx driver supports
> wl1271 and wl1273.
> Also the definition in Kconfig and header files changed respectively.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

Applied and pushed, thank you!

Luis, we're renaming also the wl1271 driver now, to wl12xx.  I remember
when Kalle moved the wl1251 that there were some problems with
compat-wireless.  Is there anything we need to do to keep things right
in compat-wireless after this change?

-- 
Cheers,
Luca.

