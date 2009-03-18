Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50351 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753128AbZCROYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 10:24:02 -0400
Content-Type: text/plain; charset=iso-8859-1
Date: Wed, 18 Mar 2009 15:23:58 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <49C0E276.5060809@gmx.net>
Message-ID: <20090318142358.125090@gmx.net> (sfid-20090318_152407_351299_208DBFC8)
MIME-Version: 1.0
References: <49C0E276.5060809@gmx.net>
Subject: Re: Ruggedized adhoc mode for large scale layer 3 mesh networks
To: elektra <onelektra@gmx.net>, linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello elektra,

I have asked you help debugging. In my little backyard all works fine n=
ow.

> A problem has always been the stability of the ad-hoc mode in large
> ad-hoc cells.

After my patches IBSS should now as stable as STA mode with the used lo=
w-level driver is.

> Typical problems are steady TSF timestamp skews, MAC timer
> skews and subsequent lockups, failed or endlessly repeating IBSS merg=
es
> to the same cell and hence IBSS cell-splits.

=46ixed BSSIDs are supported now in compat-wireless and the repeating I=
BSS merges to the same BSSID are fixed. (at mac80211 layer)

> It would be
> great if ath5k and ath9k could be used in the same way, too.

Try it out! For me It works fine now.

> We are lacking support for at least one USB chipset as well.
> Zydas/Atheros 5007UG would be great.

I work with the ar9170 driver and same Draft-N chipset which is the rep=
lacement for the ZyDAS chipset. It works okay for me, it only doesn't s=
upport rate control like minstrel for now.

Regards
Alina

P.S.:
http://git.kernel.org/?p=3Dlinux%2Fkernel%2Fgit%2Flinville%2Fwireless-t=
esting.git&a=3Dsearch&h=3DHEAD&st=3Dauthor&s=3Dx-alina%40gmx.net

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
