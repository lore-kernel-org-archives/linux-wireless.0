Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp03.msg.oleane.net ([62.161.4.3]:46019 "EHLO
	smtp03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbbLIRZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 12:25:55 -0500
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Ben Greear'" <greearb@candelatech.com>,
	<ath10k@lists.infradead.org>,
	"'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A31901C5B293@sbs2003.acksys.local> <566849DB.9040901@candelatech.com>
In-Reply-To: <566849DB.9040901@candelatech.com>
Subject: RE: ATH10K VLAN firmware issue
Date: Wed, 9 Dec 2015 18:24:43 +0100
Message-ID: <079401d132a6$7e7e2050$7b7a60f0$@acksys.fr> (sfid-20151209_182601_984875_E37B18EB)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Message d'origine-----
> De : Ben Greear [mailto:greearb@candelatech.com]
> Envoyé : mercredi 9 décembre 2015 16:34
> À : Cedric VONCKEN; ath10k@lists.infradead.org; linux-wireless
> Objet : Re: ATH10K VLAN firmware issue
> 
> This only happens when you use STA  + WDS, or is .1q broken for you in
> other cases as well?

No, this issue occurs in all modes (STA, STA + WDS, AP).

Thanks

Cedric.

> 
> Thanks,
> Ben
> 
> On 12/08/2015 06:29 AM, Cedric VONCKEN wrote:
> > 	I'm testing to transmit frame with 802.1q tag (VLAN).
> >
> > 	My client is set in STA + WDS and the netdev is bridged with eth0.
> > 	I have a computer with vlan configuration set connected to the STA
> > eth0.
> >
> > 	If I try to transmit frames with 802.1q tag, the frames are not
sent.
> > 	I checked with wireless sniffer, and I don't see the frame with VLAN
> > tag (the frames without VLAN tag are sent).
> >
> > 	I tested with firmware 10.2.4.70.14-2 from kale github,
> > 10.1.467-ct-com-full-015 from candelatech and 10.2.4.70-2 from
> > openwrt, and in all cases I have the same issue.
> >
> > 	Thanks for your help.
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-wireless" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com

