Return-Path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate2.nju.edu.cn ([202.119.32.2]:45459 "EHLO
	mail.nju.edu.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757012Ab1LHAr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 19:47:58 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.nju.edu.cn (tmailer) with ESMTP id 9A41D8FDFCD
	for <linux-wireless@vger.kernel.org>; Thu,  8 Dec 2011 08:40:06 +0800 (CST)
Received: from mail.nju.edu.cn ([127.0.0.1])
	by localhost (mail3.tmailer.org [127.0.0.1]) (theinterface-new, port 10024)
	with ESMTP id GqghhoF4UrI5 for <linux-wireless@vger.kernel.org>;
	Thu,  8 Dec 2011 08:40:05 +0800 (CST)
Received: from mail3.tmailer.org (mail3.tmailer.org [202.119.32.97])
	by mail.nju.edu.cn (tmailer) with ESMTP id 169678FDFDF
	for <linux-wireless@vger.kernel.org>; Thu,  8 Dec 2011 08:40:05 +0800 (CST)
Date: Thu, 8 Dec 2011 08:40:04 +0800 (CST)
From: =?GBK?B?1cXF9A==?= <mg0923058@smail.nju.edu.cn>
To: linux-wireless@vger.kernel.org
Message-ID: <1733962485.1371.1323304804967.JavaMail.root@mail3.tmailer.org>
Subject: =?utf-8?Q?about_Intel=C2=AE_PRO/Wireless_2200BG_Driver_for_Linux?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Dear vger,
           Thank you for the development of  IntelÂ® PRO/Wireless 2200BG Driver for Linux.
            I'm very glad to have a driver to support my laptop. Now I am learning the design of wireless driver, could you mail me the source code of IntelÂ® PRO/Wireless 2200BG Driver for Linux. I will be anxious for your reply. If possible, could you send me some advice or other reference manual about wireless driver? Thank you very much.
            Best wishes.
                                                  Zhang Peng
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
>From linux-wireless-owner@vger.kernel.org Thu Dec  8 08:02:46 2011
Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.2.5 (2008-06-10) on
	jmalinen.user.openhosting.com
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=6.0 tests=AWL,BAYES_00,RCVD_IN_DNSWL_HI
	autolearn=ham version=3.2.5
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by jmalinen.user.openhosting.com (8.13.8/8.13.8) with ESMTP id pB862kvR008899
	for <j@w1.fi>; Thu, 8 Dec 2011 01:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046Ab1LHGCj (ORCPT <rfc822;j@w1.fi>);
	Thu, 8 Dec 2011 01:02:39 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25669 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1LHGCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 01:02:38 -0500
DKIM-Signature: 	v=1; a=rsa-sha256; c=simple/simple;
  d=qca.qualcomm.com; i=rmanohar@qca.qualcomm.com;
  q=dns/txt; s=qcdkim; t=1323324158; x=1354860158;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  z=Date:=20Thu,=208=20Dec=202011=2011:32:01=20+0530|From:
   =20Rajkumar=20Manoharan=20<rmanohar@qca.qualcomm.com>|To:
   =20"Luis=20R.=20Rodriguez"=20<mcgrof@frijolero.org>|CC:
   =20<linville@tuxdriver.com>,=20<linux-wireless@vger.kerne
   l.org>|Subject:=20Re:=20[PATCH=203/4]=20ath9k:=20Restore
   =20EEPROM=20regulatory=20upon=20STA=20disconnect
   |Message-ID:=20<20111208060159.GA18304@vmraj-lnx.users.at
   heros.com>|References:=20<1323266001-12912-1-git-send-ema
   il-rmanohar@qca.qualcomm.com>=0D=0A=20<1323266001-12912-3
   -git-send-email-rmanohar@qca.qualcomm.com>=0D=0A=20<CAB
   =3DNE6XJMvmcgcz_whsVFbe+T1k_KEnW-ZOrC1K-1bZU+R_shg@mail.g
   mail.com>|MIME-Version:=201.0|Content-Transfer-Encoding:
   =208bit|In-Reply-To:=20<CAB=3DNE6XJMvmcgcz_whsVFbe+T1k_KE
   nW-ZOrC1K-1bZU+R_shg@mail.gmail.com>;
  bh=ZRfkycIXB0iw4CTyHFuhYnHnNrt+2LWoaGclnohspnA=;
  b=D69YRsnA50U9rRsmkeV6PPqPb4zYNffv9ZPlp4xevXe2xLpXPGyGpozb
   OrJdvAYnEHYqHZUR5laa4uo/fo9c16iGNZKcp/BkRtaDLmGfCZtbK8nsl
   V/8de9nxLUs3GvFVyr60x3CYg26vu42zIkMtAqVaiIzrOPTWj8f0BpSS8
   k=;
X-IronPort-AV: E=McAfee;i="5400,1158,6553"; a="144769914"
Received: from ironmsg04-l.qualcomm.com ([172.30.48.19])
  by wolverine01.qualcomm.com with ESMTP; 07 Dec 2011 22:02:08 -0800
X-IronPort-AV: E=Sophos;i="4.71,317,1320652800"; 
   d="scan'208";a="128108806"
Received: from nasanexhc08.na.qualcomm.com ([172.30.39.7])
  by Ironmsg04-L.qualcomm.com with ESMTP/TLS/AES128-SHA; 07 Dec 2011 22:02:07 -0800
Received: from NASJOEXHC01.na.qualcomm.com (10.234.56.15) by
 nasanexhc08.na.qualcomm.com (172.30.39.7) with Microsoft SMTP Server (TLS) id
 14.1.339.1; Wed, 7 Dec 2011 22:02:54 -0800
Received: from qcamail1.atheros.com (10.12.7.11) by qcamail1.atheros.com
 (10.234.56.15) with Microsoft SMTP Server (TLS) id 14.1.339.1; Wed, 7 Dec
 2011 22:02:05 -0800
Received: by qcamail1.atheros.com (sSMTP sendmail emulation); Thu, 08 Dec 2011
 11:32:01 +0530
Date: 	Thu, 8 Dec 2011 11:32:01 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] ath9k: Restore EEPROM regulatory upon STA disconnect
Message-ID: <20111208060159.GA18304@vmraj-lnx.users.atheros.com>
References: <1323266001-12912-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1323266001-12912-3-git-send-email-rmanohar@qca.qualcomm.com>
 <CAB=NE6XJMvmcgcz_whsVFbe+T1k_KEnW-ZOrC1K-1bZU+R_shg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB=NE6XJMvmcgcz_whsVFbe+T1k_KEnW-ZOrC1K-1bZU+R_shg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.12.7.11]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: 	linux-wireless@vger.kernel.org
Content-Length: 3572

On Wed, Dec 07, 2011 at 01:37:49PM -0800, Luis R. Rodriguez wrote:
> On Wed, Dec 7, 2011 at 5:53 AM, Rajkumar Manoharan
> <rmanohar@qca.qualcomm.com> wrote:
> > The current regulatory for world roaming mode cards might be
> > overriden by country IE from the assiciated AP. But these
> > regulatory values are failed to be restored on disconnection.
> > This patch ensures to resotre regulatry values at driver side.
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/main.c |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> > index 424289f..a4dbb7b 100644
> > --- a/drivers/net/wireless/ath/ath9k/main.c
> > +++ b/drivers/net/wireless/ath/ath9k/main.c
> > @@ -2046,6 +2046,14 @@ static void ath9k_config_bss(struct ath_softc *sc, struct ieee80211_vif *vif)
> >                sc->sc_flags &= ~SC_OP_ANI_RUN;
> >                del_timer_sync(&common->ani.timer);
> >                memset(&sc->caldata, 0, sizeof(sc->caldata));
> > +               /*
> > +                * Restore regulatory values that might be updated
> > +                * by country IEs.
> > +                */
> > +               if (!ath_is_world_regd(&common->regulatory) &&
> > +                   ath_is_world_regd(&common->reg_world_copy))
> > +                       memcpy(&common->regulatory, &common->reg_world_copy,
> > +                              sizeof(struct ath_regulatory));
> >        }
> 
> NACK, this patch should not be required given that patch [2/4] in this
> series restores this on the reg_notifier() for the
> NL80211_REGDOM_SET_BY_CORE case -- the trick is that when cfg80211
> detects not only a disconnect, but any regulatory restore, it will
> *always* send a reg core hint! Again the hunk from patch [2/4] was:
> 
> @@ -363,14 +381,37 @@ int ath_reg_notifier_apply(struct wiphy *wiphy,
>                return 0;
> 
>        switch (request->initiator) {
> -       case NL80211_REGDOM_SET_BY_DRIVER:
>        case NL80211_REGDOM_SET_BY_CORE:
> +               /*
> +                * If common->reg_world_copy is world roaming it means we *were*
> +                * world roaming... so we now have to restore that data.
> +                */
> +               if (!ath_is_world_regd(&common->reg_world_copy))
> +                       break;
> +
> +               memcpy(reg, &common->reg_world_copy,
> +                      sizeof(struct ath_regulatory));
> +               break;
> +       case NL80211_REGDOM_SET_BY_DRIVER:
>        case NL80211_REGDOM_SET_BY_USER:
>                break;
> 
> Can you please test without this patch and ensure you get the data
> properly restored?
> 
But the regulatory updates are ignored for CUSTOM_REGULATORY cards
at wiphy_update_regulatory. Isn't it?

        if (initiator == NL80211_REGDOM_SET_BY_CORE &&
            wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY) {
                REG_DBG_PRINT("Ignoring regulatory request %s "
                              "since the driver uses its own custom "
                              "regulatory domain\n",
                              reg_initiator_name(initiator));
                return true;

To ensure that the regulatory is restored always, I did it at bss_info_change.

--
Rajkumar
