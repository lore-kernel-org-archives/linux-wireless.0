Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:13690 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbXK2JVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 04:21:11 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: set interface MAC address after driver's start() is called
Date: Thu, 29 Nov 2007 10:22:06 +0100
Cc: Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linville@tuxdriver.com
References: <1196300047-6201-1-git-send-email-yi.zhu@intel.com> <1196326174.6058.173.camel@johannes.berg> <1196327209.7614.113.camel@debian.sh.intel.com>
In-Reply-To: <1196327209.7614.113.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711291022.07114.hs4233@mail.mn-solutions.de> (sfid-20071129_092117_970488_491228F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Users see 00:00:00:00:00:00 address before up.

How does this interact with udev?  udev uses the MAC address in 
/etc/udev/rules.d/z25_persistent-net.rules ?
