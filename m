Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40258 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757490AbZDSOdl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 10:33:41 -0400
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 19 Apr 2009 16:33:37 +0200
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1240147370.898.0.camel@johannes.local>
Message-ID: <20090419143337.158810@gmx.net> (sfid-20090419_163344_924684_BA1BE2A8)
MIME-Version: 1.0
References: <1240094996.21583.1.camel@johannes.local>	
 (sfid-20090419_005015_625875_1781AFCD) <1240147370.898.0.camel@johannes.local>
Subject: Re: [RFC/RFT] cfg80211/nl80211: add IBSS API
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes!

> Hmm, I forgot one thing -- you may want to create an IBSS on a specif=
ic
> channel, but still allow it scan for other IBSSes. I guess we need a
> flag for that and not make "channel set" imply fixed channel.

In cfg80211 an indication for channel auto select is needed for IBSS an=
d _STA_ mode, to implement with it the old wext interface. If not set t=
he channel shouldn't be changed. If you not want store this flag in cfg=
80211, you must store it in the channel functions of wext to have the s=
ame behavior like now.

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
