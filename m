Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50932 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756953AbZDSNfr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 09:35:47 -0400
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 19 Apr 2009 15:35:44 +0200
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1240147050.25826.5.camel@johannes.local>
Message-ID: <20090419133544.158820@gmx.net> (sfid-20090419_153550_588554_A4B06C0C)
MIME-Version: 1.0
References: <1240094996.21583.1.camel@johannes.local>	
 (sfid-20090419_005015_625875_1781AFCD)
 <1240097845.25826.1.camel@johannes.local>	 <20090419125212.158800@gmx.net>
 (sfid-20090419_145246_566920_BF082D12) <1240147050.25826.5.camel@johannes.local>
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes!

> Because you don't associate with an IBSS?

This is only a name, but the call does mostly the same. I think having =
one generic API goes more along with the UNIX philosophy, than having f=
or each mode a defend API, on which almost only the names of the calls =
are deferent.

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
