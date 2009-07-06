Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10976 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbZGFQcz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 12:32:55 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Jul 2009 09:32:59 -0700
Date: Mon, 6 Jul 2009 09:32:57 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: xxiao <austinxxh-ath9k@yahoo.com>, <linux-wireless@vger.kernel.org>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Peter Tarjan <peter.tarjan@birdtelecom.hu>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>, <vitaly@luban.org>
Subject: adhoc 11n support
Message-ID: <20090706163257.GF5523@mosca>
References: <688927.48007.qm@web55301.mail.re4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <688927.48007.qm@web55301.mail.re4.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Jouni's response to me regarding 11n "adhoc" as per IEEE:

<jm> mcgrof: IBSS support in 802.11n is not a specific part of the draft, i.e., one needs to go through 
                the full draft.. for example, there are IBSS-related specification in 7.3.2.57, 9.13.3.1, 10.3.2.2.2, 
                11.5.1.1, 11.9.7.2, 11.14.1, 11.14.2; in addition, some AP mode requirements apply, e.g., for radar 
                detection/DFS, but we are currently handling those by just denying IBSS on channels that could require DFS

So if you get a chance please be sure to read through all that and then send patches for mac80211.

  Luis
