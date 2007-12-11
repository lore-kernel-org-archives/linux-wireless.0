Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:42438 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbXLKMwL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 07:52:11 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: mac80211 ethtool support
Date: Tue, 11 Dec 2007 13:50:25 +0100
Cc: linux-wireless@vger.kernel.org
References: <1197361048.3170.381.camel@debian.sh.intel.com>
In-Reply-To: <1197361048.3170.381.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712111350.25522.mb@bu3sch.de> (sfid-20071211_125215_308153_24C6520A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 11 December 2007 09:17:28 Zhu Yi wrote:
> I want to add ethtool .get_eeprom and .get_eeprom_len support for
> iwlwifi. But it seems mac80211 hides the netdev structure from the
> driver. What's the suggested way for doing so (i.e dump EEPROM) for
> mac80211 devices?

In ssb we simply create a sysfs file for this.

-- 
Greetings Michael.
