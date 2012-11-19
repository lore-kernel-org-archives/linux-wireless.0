Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1748 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab2KSU5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 15:57:34 -0500
Message-ID: <50AA9D34.3070106@broadcom.com> (sfid-20121119_215739_049838_FC656B09)
Date: Mon, 19 Nov 2012 21:57:24 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Bill Pemberton" <wfp5p@virginia.edu>
cc: gregkh@linuxfoundation.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Jiri Slaby" <jirislaby@gmail.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	"Simon Kelley" <simon@thekelleys.org.uk>,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	"Stanislav Yakovlev" <stas.yakovlev@gmail.com>,
	"Dan Williams" <dcbw@redhat.com>,
	"Christian Lamparter" <chunkeey@googlemail.com>,
	"Herton Ronaldo Krzesinski" <herton@canonical.com>,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Chaoming Li" <chaoming_li@realsil.com.cn>,
	"Luciano Coelho" <coelho@ti.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH 196/493] net/wireless: remove use of __devinit
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
 <1353349642-3677-196-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-196-git-send-email-wfp5p@virginia.edu>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/2012 07:22 PM, Bill Pemberton wrote:
> CONFIG_HOTPLUG is going away as an option so __devinit is no longer
> needed.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
> Cc: brcm80211-dev-list@broadcom.com
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c | 2 +-

For brcm80211 driver change.

Gr. AvS

