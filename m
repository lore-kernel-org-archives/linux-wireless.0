Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:3360 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbYFZC50 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 22:57:26 -0400
Subject: Re: [Q] ath5k : doesn't support AP mode?
From: Pavel Roskin <proski@gnu.org>
To: cs010101@gmail.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3>
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3>
Content-Type: text/plain; charset=euc-kr
Date: Wed, 25 Jun 2008 22:57:24 -0400
Message-Id: <1214449044.18897.15.camel@dv> (sfid-20080626_045727_909115_82C1268F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-26 at 11:54 +0900, =B1=E8=BF=B5=C8=AF wrote:
> Hello~
>=20
> Lately, I've researched for AP mode in linux. I'm testing 802.11a abo=
ut
> atheros 5414, rt61, zyDAS USB(a/b/g).
> I know AP mode are supportted on Prism chipset, Atheros(madwifi).
> then how the nic using atheros 5414 chipset?

mac80211 based drivers including ath5k don't support AP mode yet.
Please use MadWifi with it for now.

--=20
Regards,
Pavel Roskin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
