Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47276 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751338AbZCXVKw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 17:10:52 -0400
Cc: linux-wireless@vger.kernel.org, kalle.valo@iki.fi
Content-Type: text/plain; charset=iso-8859-1
Date: Tue, 24 Mar 2009 22:10:49 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <c03d7e680903241358ya809dabhcc75eeca14782ff3@mail.gmail.com>
Message-ID: <20090324211049.282460@gmx.net> (sfid-20090324_221056_656674_7AC9FB49)
MIME-Version: 1.0
References: <c03d7e680903240959s51aa4864uaad281bd7487e823@mail.gmail.com>	
 <871vsmrekh.fsf@litku.valot.fi>	
 <c03d7e680903241348x27363902m764c25a9a439d419@mail.gmail.com>	
 <1237928031.4320.133.camel@johannes.local>
 <c03d7e680903241358ya809dabhcc75eeca14782ff3@mail.gmail.com>
Subject: Re: Adhoc-demo support in mac80211
To: ming li <mingli@cs.umass.edu>, johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

> BTW, even if you do "iwconfig wlan0 ap..." the IBSS domain still migh=
t
> split when the link loss rate is high, right?

No, the BSSID is fixed for ever. I have implement it.

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
