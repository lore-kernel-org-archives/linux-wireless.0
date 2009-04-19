Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51137 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755165AbZDSSDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 14:03:21 -0400
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 19 Apr 2009 20:03:14 +0200
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1240163391.11795.59.camel@violet>
Message-ID: <20090419180314.23710@gmx.net> (sfid-20090419_200324_078277_D66DA478)
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
 (sfid-20090419_175352_161479_A88396A3)
 <1240156631.917.1.camel@johannes.local>	 <20090419161316.158790@gmx.net>	
 (sfid-20090419_181324_681308_BAEAE072)
 <1240158381.917.21.camel@johannes.local>	 <20090419165443.158820@gmx.net>	
 (sfid-20090419_185516_519795_36D34B9B)
 <1240160241.28138.4.camel@johannes.local>	 <20090419173354.158790@gmx.net>
 <1240163391.11795.59.camel@violet>
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
To: Marcel Holtmann <marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Marcel!

> you argue command line tools against kernel exposed API.

I use the command line syntax to explain the kernel API.

> Both have
> nothing to do with each other on that level.

Most commands are mapped 1:1. And the API easier to understand if it is=
 so.

> If you don't like the iw
> syntax then fix it and provide a command that does all three task for
> you. No need to mess with the kernel interface for that.

I think now, provide a high-level command besides the low-level command=
s is a good idea. We need it for the old wext interface anyway. Then we=
xt can only call this command and don't need own intelligence. So than =
it's only a foolish wrapper, like it should.

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
