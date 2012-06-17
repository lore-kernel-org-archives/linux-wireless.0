Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47248 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab2FQVqH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jun 2012 17:46:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SgNII-0004am-2n
	for linux-wireless@vger.kernel.org; Sun, 17 Jun 2012 23:46:02 +0200
Received: from c-69-245-126-173.hsd1.mi.comcast.net ([69.245.126.173])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jun 2012 23:46:02 +0200
Received: from ilhebe999 by c-69-245-126-173.hsd1.mi.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jun 2012 23:46:02 +0200
To: linux-wireless@vger.kernel.org
From: Ouyang <ilhebe999@gmail.com>
Subject: make moduels tx.c error
Date: Sun, 17 Jun 2012 21:45:49 +0000 (UTC)
Message-ID: <loom.20120617T234255-222@post.gmane.org> (sfid-20120617_234645_000510_CA43C99B)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Anyone can tell me how to figure this problem? I do not have much experience on
linux kernel compiling.
make modules
make[1]: Nothing to be done for `all'.
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC [M]  net/mac80211/tx.o
net/mac80211/tx.c: In function ‘ieee80211_tx’:
net/mac80211/tx.c:1327:2: error: implicit declaration of function
‘ieee80211_tx_prepare’ [-W
net/mac80211/tx.c: At top level:
net/mac80211/tx.c:1601:1: error: conflicting types for ‘ieee80211_tx_prepare’
net/mac80211/tx.c:1327:16: note: previous implicit declaration of
‘ieee80211_tx_prepare’ was
net/mac80211/tx.c: In function ‘ieee80211_tx_prepare’:
net/mac80211/tx.c:1643:7: warning: passing argument 1 of
‘__ieee80211_parse_tx_radiotap’ fro
net/mac80211/tx.c:1516:13: note: expected ‘struct sk_buff *’ but argument is of
type ‘struct
net/mac80211/tx.c:1643:7: error: too many arguments to function
‘__ieee80211_parse_tx_radiot
net/mac80211/tx.c:1516:13: note: declared here
net/mac80211/tx.c: In function ‘ieee80211_monitor_start_xmit’:
net/mac80211/tx.c:1790:2: error: implicit declaration of function
‘ieee80211_parse_tx_radiot
cc1: some warnings being treated as errors
make[2]: *** [net/mac80211/tx.o] Error 1
make[1]: *** [net/mac80211] Error 2
make: *** [net] Error 2


