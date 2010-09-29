Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56801.mail.re3.yahoo.com ([66.196.97.75]:46897 "HELO
	web56801.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752676Ab0I2NAE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 09:00:04 -0400
Message-ID: <733457.84719.qm@web56801.mail.re3.yahoo.com>
Date: Wed, 29 Sep 2010 06:00:00 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [BUG] compat: broken driver-select always compiles ath6kl & brcm80211
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Latest compat-wireless manifests a bug when "scripts/driver-select" is invoked. Regardless of which driver is selected (zd1211rw for example),  ath6kl and brcm80211 are always compiled along with the designated module of choice.

I tried looking in to it, but don't really have time. Perhaps someone would like to investigate.

Walter.


      
