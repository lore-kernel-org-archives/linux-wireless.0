Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45845 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506Ab1IPU6j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 16:58:39 -0400
Message-ID: <4E73B822.5010403@hauke-m.de> (sfid-20110916_225843_250174_B29C6272)
Date: Fri, 16 Sep 2011 22:57:06 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Compat-wireless release based on wireless-testing
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As kernel.org is still down and no new version of linux-next is
available I created a compat-wireless version based on recent
wireless-testing ( master-2011-09-14 ).

It can be downloaded here and is compile tested with all last kernel
minor version >= 2.6.27:
http://hauke-m.de/files/compat-wireless/compat-wireless-wl-2011-09-16.tar.bz2

The source code for compat-wireless can be fond on github:
compat-wireless: https://github.com/hauke/compat-wireless/tree/hauke-wl
compat: https://github.com/hauke/compat/tree/hauke

This release was created manually and I plan to do other releases when
wireless-testing updates, till no new version of linux-next is
available, but I will not promise anything. ;-)

Have fun with the recent wireless code.

Hauke
