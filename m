Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53496 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbZJWOIS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 10:08:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: ath5k: no further txbuf available, dropping packet
Date: Fri, 23 Oct 2009 16:08:16 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910231608.18676.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k breaks in AP mode after some operation time and keeps throwing
this message:

[2096249.446071] ath5k phy0: no further txbuf available, dropping packet

Driver is yesterday's compat-wireless on 2.6.31.1

-- 
Greetings, Michael.
