Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37248 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1JQR7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 13:59:38 -0400
Received: by gyb13 with SMTP id 13so3224675gyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2011 10:59:37 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9s_Garc=EDa_Saavedra?=
	<andres.garcia.saavedra@gmail.com>
Date: Mon, 17 Oct 2011 19:59:17 +0200
Message-ID: <CADxqDgHYu51DQXOLT3eA=6PckSmXc42BFUF=Z7qZ_Cs45T1GjQ@mail.gmail.com> (sfid-20111017_195941_297567_E944AF05)
Subject: brcmfmac driver implementation: Questions
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I would like to test some custom powersaving algorithms for 802.11abg
WLANs on some current android smartphone (e.g., nexus one). My
question is regarding the brcmfmac driver implementation for BCM4329
chipsets:

* The current open source implementation of the driver, brcmfmac, does
ONLY support 11n PHY?
* Does this driver interfaces the mac80211 operations or "acts as" a
mac80211 driver itself talking to cfg80211/nl80211?
* Does the chipset/current implementation support sleep/awake
triggers? (or at least quiet elements?)

Thanks for your answer,
Andrés
