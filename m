Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47493 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752608AbZACAAb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 19:00:31 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Sat, 03 Jan 2009 01:00:28 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090103000028.302750@gmx.net> (sfid-20090103_010037_599013_5390FD9B)
MIME-Version: 1.0
Subject: Invalid BSSID handling?
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

what BSSID addresses should be treaded as invalid, by manual setting? H=
andling in mac80211 now is really magic. Multicast MAC addresses are ac=
cepted but the IEEE80211_STA_BSSID_SET flag isn't set, so that they are=
 handled as if they are automatically detected and selected.

The madwifi accepts all BSSIDs except 00:00:00:00:00:00 and ff:ff:ff:ff=
:ff:ff. Should mac80211 allow all BSSIDs like madwifi, or should it bet=
ter treat multicast MAC addresses as 00:00:00:00:00:00, or an other han=
dling?

Regards
Alina

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
