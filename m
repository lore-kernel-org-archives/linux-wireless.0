Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39784 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab3JCVAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 17:00:10 -0400
Date: Thu, 3 Oct 2013 16:57:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org
Subject: Re: [PATCH] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680
 hardware
Message-ID: <20131003205710.GH3142@tuxdriver.com> (sfid-20131003_230016_138238_F05C6504)
References: <1380234106-12802-1-git-send-email-k.eugene.e@gmail.com>
 <CAFSJ42bybEGtkzJ99fZHrcPs=gTnvJVHxM7d8anJvn1VOs7V7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFSJ42bybEGtkzJ99fZHrcPs=gTnvJVHxM7d8anJvn1VOs7V7A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 26, 2013 at 11:25:18PM +0100, Eugene Krasnikov wrote:
> Hi John,
> 
> This is the latest version of wcn36xx driver on top of current
> wireless-next tree. Please let me know if you have any problems with
> applying it.
> 
> 2013/9/26 Eugene Krasnikov <k.eugene.e@gmail.com>:
> > This is a mac80211 driver for Qualcomm WCN3660/WCN3680 devices. So
> > far WCN3660/WCN3680 is available only on MSM platform.
> >
> > Firmware can be found here:
> > https://www.codeaurora.org/cgit/external/hisense/platform/vendor/qcom-opensource/wlan/prima/tree/firmware_bin?h=8130_CS
> >
> > Wiki page is available here:
> > http://wireless.kernel.org/en/users/Drivers/wcn36xx
> >
> > A lot people made a contribution to this driver. Here is the list in
> > alphabetical order:
> >
> > Eugene Krasnikov <k.eugene.e@gmail.com>
> > Kalle Valo <kvalo@qca.qualcomm.com>
> > Olof Johansson <dev@skyshaper.net>
> > Pontus Fuchs <pontus.fuchs@gmail.com>
> > Yanbo Li <yanbol@qti.qualcomm.com>
> >
> > Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>

'make allyesconfig' yield this:

  LD      drivers/net/wireless/ath/ath.o
  LD      drivers/net/wireless/ath/built-in.o
drivers/net/wireless/ath/wcn36xx/built-in.o: In function `_GLOBAL__sub_I_65535_0_wcn36xx_set_default_rates':
/home/linville/git/wireless-next/drivers/net/wireless/ath/wcn36xx/main.c:302: multiple definition of `debug_mask'
drivers/net/wireless/ath/ath6kl/built-in.o:/home/linville/git/wireless-next/drivers/net/wireless/ath/ath6kl/cfg80211.c:1208: first defined here
make[2]: *** [drivers/net/wireless/ath/built-in.o] Error 1
make[1]: *** [drivers/net/wireless/ath] Error 2
make: *** [drivers/net/wireless/] Error 2

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
