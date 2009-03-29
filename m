Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49774 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751416AbZC2GQl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 02:16:41 -0400
Message-ID: <49CF1245.1040804@gmx.de> (sfid-20090329_081644_836181_05C3EC42)
Date: Sun, 29 Mar 2009 08:16:37 +0200
From: ZeroBeat <ZeroBeat@gmx.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: gcc error 385 in agg-tx.c
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Gentlemen.

Since the snapshot from 28th of march gcc reports an error during the=20
compilation of agg-tx.c:

/net/mac80211/agg-tx.c: In Funktion =BBieee80211_agg_splice_packets=AB:
/net/mac80211/agg-tx.c:385: Fehler: Implizite Deklaration der Funktion=20
=BBskb_queue_splice_tail_init=AB


There are also some warnings in b43 module and ipw2x00 module (but i=20
think this is a problem of gcc 4.3.2).
=20
/drivers/net/wireless/b43/main.c: In Funktion =BBb43_print_fw_helptext=AB=
:
/drivers/net/wireless/b43/main.c:1971: Warnung: Format ist kein=20
Zeichenkettenliteral, und keine Formatargumente
/drivers/net/wireless/b43/main.c:1973: Warnung: Format ist kein=20
Zeichenkettenliteral, und keine Formatargumente
/drivers/net/wireless/b43/main.c: In Funktion =BBb43_request_firmware=AB=
:
/drivers/net/wireless/b43/main.c:2233: Warnung: Format ist kein=20
Zeichenkettenliteral, und keine Formatargumente

/drivers/net/wireless/ipw2x00/libipw_wx.c: In Funktion=20
=BBieee80211_wx_set_encodeext=AB:
/drivers/net/wireless/ipw2x00/libipw_wx.c:622: Warnung: Format ist kein=
=20
Zeichenkettenliteral, und keine Formatargumente

My system:
UBUNTU 8.10
2.6.27-11-generic
gcc (Ubuntu 4.3.2-1ubuntu12) 4.3.2

compat-wireless works fine using the following adapters:
ALFA NETWORKS AWUS036H (RTL8187)
DELOCK 95800 (RT2561)
D-Link DWL-G650 AirPlus XTremeG Recv C1 (Atheros 5001X+)
D-Link DWL-G520 (Atheros 5212)

*Best regards
Michael


*





--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
