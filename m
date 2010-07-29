Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:22038 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab0G2Fct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 01:32:49 -0400
Subject: Re: [PATCH] wl1271: add get_survey callback in order to get
 channel noise
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>
In-Reply-To: <1280349740-26973-1-git-send-email-linville@tuxdriver.com>
References: <1280349740-26973-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 08:00:26 +0300
Message-ID: <1280379626.6475.77.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-07-28 at 22:42 +0200, ext John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/wl12xx/wl1271.h      |    3 +++
>  drivers/net/wireless/wl12xx/wl1271_main.c |   17 +++++++++++++++++
>  drivers/net/wireless/wl12xx/wl1271_rx.c   |    7 +++++++
>  3 files changed, 27 insertions(+), 0 deletions(-)
> 

I was thinking about the algorithm to get the noise, but then noticed
Kalle Valo's comment for wl1251. Pretty much the same applies here.

Acked-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>



-Juuso


