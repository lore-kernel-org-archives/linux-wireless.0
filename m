Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:1451 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbXIMXzl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2007 19:55:41 -0400
Received: by py-out-1112.google.com with SMTP id u77so1421649pyb
        for <linux-wireless@vger.kernel.org>; Thu, 13 Sep 2007 16:55:38 -0700 (PDT)
Message-ID: <43e72e890709131655m72555cc6qe025246dd6e97a43@mail.gmail.com>
Date: Thu, 13 Sep 2007 19:55:37 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 0/3] Remove Vendor specific modes and modulations from mac80211
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>, "Jiri Slaby" <jirislaby@gmail.com>,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Johannes Berg" <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patches remove vendor specific modes and modulations
from mac80211. We will later need to add support for vendor/dirver
specific modes and rates if we want to export them in a general form
for drivers. Vendor specific modes/rates I am aware of are:

* Atheros's Turbo, XR
* Broadcom's 125 High Speed Mode
* Conexant's Nitro
* Airgo Network's first MIMO-based extensions

Johill, please verify changes on ieee80211_ioctl.c and mac80211.h,
they're a bit different from your changes. Apologies but I can't test
against hostapd. My regulatory work will depend on these patches.

 Luis
