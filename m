Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:33467 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZCJSsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 14:48:19 -0400
Received: by wf-out-1314.google.com with SMTP id 28so2740963wfa.4
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 11:48:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <548cdfc20903100908y6ce7809dw2da12ab8b5cd132b@mail.gmail.com>
References: <548cdfc20903100908y6ce7809dw2da12ab8b5cd132b@mail.gmail.com>
Date: Tue, 10 Mar 2009 14:48:16 -0400
Message-ID: <b6c5339f0903101148o1322a6c0xb6871c6576d01922@mail.gmail.com> (sfid-20090310_194822_268414_DE8D0475)
Subject: Re: ath5k crashing in device probe
From: Bob Copeland <me@bobcopeland.com>
To: Pauli Nieminen <suokkos@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 10, 2009 at 12:08 PM, Pauli Nieminen <suokkos@gmail.com> wr=
ote:
> Hello!
>
> Original bug report to ubuntu bugs:
> https://bugs.launchpad.net/bugs/339496 This is regression from 2 week=
s

Probably the appropriate thing to do...

> [ =A0 18.942981] =A0[<ffffffff8041f2de>] ? __const_udelay+0x4e/0x50
> [ =A0 18.942989] =A0[<ffffffffa02c750a>] lbm_cw_wiphy_register+0x17a/=
0x210
> [lbm_cw_cfg80211]
> [ =A0 18.942998] =A0[<ffffffffa02f1276>]
> lbm_cw_ieee80211_register_hw+0xb6/0x440 [lbm_cw_mac80211]
> [ =A0 18.943019] =A0[<ffffffffa0342995>] ath5k_pci_probe+0x10b5/0x148=
a [ath5k]

lbm_cw_mac80211 is some ubuntu special sauce, I think (I guess lbm =3D=3D
linux-backport-modules)?  Does this happen with wireless-testing or any
kernel.org tree?

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
