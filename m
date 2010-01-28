Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:8897 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab0A1R1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 12:27:50 -0500
Message-ID: <4B61C8F3.6000508@am.sony.com>
Date: Thu, 28 Jan 2010 09:27:15 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
MIME-Version: 1.0
To: Hamish Guthrie <hamish.guthrie@sonycom.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"cbe-oss-dev@ozlabs.org" <cbe-oss-dev@ozlabs.org>
Subject: Re: [PATCH 1/2] ps3_gelic_wireless: Remove PS3 gelic legacy wpa support
References: <1264679650-14201-1-git-send-email-hamish.guthrie@sonycom.com> <1264679650-14201-2-git-send-email-hamish.guthrie@sonycom.com>
In-Reply-To: <1264679650-14201-2-git-send-email-hamish.guthrie@sonycom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/2010 03:54 AM, Hamish Guthrie wrote:
> The current PS3 gelic wireless driver has support for wireless
> extensions. The original PS3 gelic wireless driver exposed a
> dedicated API for a dedicated wpa_supplicant driver. This old
> API could be enabled with CONFIG_GELIC_WIRELESS_OLD_PSK_INTERFACE,
> however, as this is not being used by any distros, and it is being
> removed from the driver and from wpa_supplicant.
> 
> Signed-off-by: Hamish Guthrie <hamish.guthrie@sonycom.com>
> ---
>  arch/powerpc/configs/ppc64_defconfig |    1 -
>  arch/powerpc/configs/ps3_defconfig   |    1 -
>  drivers/net/Kconfig                  |   14 ----
>  drivers/net/ps3_gelic_wireless.c     |  137 ----------------------------------
>  4 files changed, 0 insertions(+), 153 deletions(-)

0 insertions, very cool!

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>

