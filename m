Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49498 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757131AbZDSQNT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 12:13:19 -0400
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 19 Apr 2009 18:13:16 +0200
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1240156631.917.1.camel@johannes.local>
Message-ID: <20090419161316.158790@gmx.net> (sfid-20090419_181324_681308_BAEAE072)
MIME-Version: 1.0
References: <1240094996.21583.1.camel@johannes.local>	
 (sfid-20090419_005015_625875_1781AFCD)
 <1240097845.25826.1.camel@johannes.local>	 <20090419125212.158800@gmx.net>	
 (sfid-20090419_145246_566920_BF082D12)
 <1240147050.25826.5.camel@johannes.local>	 <20090419133544.158820@gmx.net>	
 (sfid-20090419_153615_967882_D1A9F951)
 <1240148519.898.3.camel@johannes.local>	 <20090419140523.158830@gmx.net>	
 (sfid-20090419_160555_446977_A429511B)
 <1240150277.898.7.camel@johannes.local>	 <20090419151629.158790@gmx.net>	
 (sfid-20090419_171702_263242_9A8C16F9)
 <1240154704.898.18.camel@johannes.local>	 <20090419155319.158810@gmx.net>
 (sfid-20090419_175352_161479_A88396A3) <1240156631.917.1.camel@johannes.local>
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> You don't need wpa_supplicant, you just need an SME for that. Eventua=
lly
> we'll implement one in iw.

You need one simple SME for compatibility with wext in the kernel-space=
=2E Why not allow to access it with nl80211?

Regards
Alina

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
