Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55710 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab0LGN0A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 08:26:00 -0500
Message-ID: <4CFE361F.9080305@ti.com>
Date: Tue, 07 Dec 2010 15:26:55 +0200
From: Shahar Levi <shahar_levi@ti.com>
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH ] linux-firmware: wl12xx-Add Access Point Firmware & NVS
 to the wl12xx Driver
References: <1290584858-6595-1-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1290584858-6595-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/2010 09:47 AM, Shahar Levi wrote:
> wl1271-fw-ap.bin is access point mode FW support to the wl12xx driver.
> Access point uses a separate firmware from station and has a different
> initialization sequence.
>
> Signed-off-by: Shahar Levi<shahar_levi@ti.com>
> ---
>   WHENCE                            |   13 +++++++++----
>   ti-connectivity/wl1271-fw-ap.bin  |  Bin 0 ->  260992 bytes
>   ti-connectivity/wl1271-nvs-ap.bin |  Bin 0 ->  912 bytes
>   3 files changed, 9 insertions(+), 4 deletions(-)
>   create mode 100644 ti-connectivity/wl1271-fw-ap.bin
>   create mode 100644 ti-connectivity/wl1271-nvs-ap.bin
>
...
Dear David,
I would greatly appreciate if you update when that patch will be apply
to linux-firmware.

Thank you in advance.
Regards,
Shahar
