Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate09.web.de ([217.72.192.184]:38852 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbZG1KnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 06:43:23 -0400
Date: Tue, 28 Jul 2009 12:12:37 +0200
Message-Id: <1737871759@web.de>
MIME-Version: 1.0
From: Chunkeey@web.de
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: Re: [PATCH] ar9170: remove EXPERIMENTAL marker
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <lrodriguez@atheros.com> wrote:

> Cc: Christian Lamparter <chunkeey@web.de>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> drivers/net/wireless/ath/ar9170/Kconfig | 3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ar9170/Kconfig b/drivers/net/wireless/ath/ar9170/Kconfig
> index de4281f..05918f1 100644
> --- a/drivers/net/wireless/ath/ar9170/Kconfig
> +++ b/drivers/net/wireless/ath/ar9170/Kconfig
> @@ -1,12 +1,13 @@
> config AR9170_USB
> tristate "Atheros AR9170 802.11n USB support"
> - depends on USB && MAC80211 && WLAN_80211 && EXPERIMENTAL
> + depends on USB && MAC80211 && WLAN_80211
>
huh? there are still:
- 9 TODOs
- 7 XXX
- 3 FIXMEs
left _to do_ for the driver.

Not to mention known problems and bugs!

________________________________________________________________
Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://produkte.web.de/go/02/

