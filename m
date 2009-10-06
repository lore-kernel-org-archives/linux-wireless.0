Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ted.prima.de ([83.97.48.3]:47273 "EHLO ted.prima.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758364AbZJFTSR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 15:18:17 -0400
Received: from localhost ([127.0.0.1])
	by ted.prima.de with esmtp (Exim 4.63)
	(envelope-from <riffer@penny.prima.de>)
	id 1MvFCz-0006qY-FS
	for linux-wireless@vger.kernel.org; Tue, 06 Oct 2009 20:56:27 +0200
Received: from ted.prima.de ([127.0.0.1])
	by localhost (ted.prima.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vmpw8tm774FL for <linux-wireless@vger.kernel.org>;
	Tue,  6 Oct 2009 20:56:21 +0200 (CEST)
Received: from marcy.prima.de ([83.97.48.8])
	by ted.prima.de with esmtp (Exim 4.63)
	(envelope-from <riffer@penny.prima.de>)
	id 1MvFCv-0006qL-H0
	for linux-wireless@vger.kernel.org; Tue, 06 Oct 2009 20:56:21 +0200
Received: from uucp by marcy.prima.de with local-rmail (Exim 4.69)
	(envelope-from <riffer@penny.prima.de>)
	id 1MvFCt-0003nk-Fl
	for linux-wireless@vger.kernel.org; Tue, 06 Oct 2009 20:56:21 +0200
Received: from [192.168.0.127] (nb-riffer [192.168.0.127])
	by penny.prima.de (Postfix) with ESMTP id D8BB411C0A1
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2009 20:57:20 +0200 (CEST)
Message-ID: <4ACB91E7.5010405@penny.prima.de>
Date: Tue, 06 Oct 2009 20:52:23 +0200
From: Riffer <riffer@penny.prima.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Bleeding Edge b43 dated since 30 of september no longer working &
 today does not even compile.
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

The problem is described in the topic.

Symptons:

The driver gets loaded and all depending drivers too but the wireless
device does not come up (iwconfig shows nothing, "ADDRCONF(NETDEV_UP):"
does not follow in /var/log/messages after modprobing).

Any hints for me? Maybe a new functionality that has to be triggered?

I am using the bleeding drivers on a Compaq 615 Notebook having PCI ID
14e4:4315 (Broadcom) under Ubuntu 9.04 with kernel
2.6.30-02063006-generic AMD64.

Currently I am testing the bleeding edge driver nearly every day because
I am a very curious man :-) and my hope is to one day find the best
(fast and stable) wireless driver I can get for my notebook ;-)

The most stable driver at the moment (for me) is the archive from the
16th of september and as you can read here
http://forums.opensuse.org/2045067-post38.html bleeding edge had already
a failure that stopped working from 17th to 26th of september (for me)
where Larry pointed to a problem with cfg80211 (I am using WPA2).

Another problem is that the archive from today can not be compiled:

/home/riffer/bleeding/compat-wireless-2009-10-06/drivers/net/wireless/ath/main.o
In file included from
/home/riffer/bleeding/compat-wireless-2009-10-06/include/net/mac80211.h:22,
                 from
/home/riffer/bleeding/compat-wireless-2009-10-06/drivers/net/wireless/ath/ath.h:22,
                 from
/home/riffer/bleeding/compat-wireless-2009-10-06/drivers/net/wireless/ath/main.c:20:
/home/riffer/bleeding/compat-wireless-2009-10-06/include/net/cfg80211.h:1146:
Fehler: »ETHTOOL_BUSINFO_LEN« ist hier nicht deklariert (nicht in einer
Funktion)
(translation:
Error »ETHTOOL_BUSINFO_LEN« is not declared here (not in a function))

best regards

p.s.:
I am only a user and not a developer. If my posting to this mailing-list
is a mistake please tell me!!!
-- 
Riffer
