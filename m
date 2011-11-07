Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38852 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab1KGJ4B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 04:56:01 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RNLvs-0006HU-1i
	for linux-wireless@vger.kernel.org; Mon, 07 Nov 2011 10:56:00 +0100
Subject: Re: [ANN] iw: v3.2
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <E1RNLZe-0005kI-RP@sipsolutions.net>
References: <E1RNLZe-0005kI-RP@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 10:55:55 +0100
Message-ID: <1320659755.3993.33.camel@jlt3.sipsolutions.net> (sfid-20111107_105611_042860_E299639A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-07 at 10:34 +0100, wireless@sipsolutions.net wrote:
> A new release of iw (v3.2) is available at:
> 
> http://wireless.kernel.org/download/iw/iw-3.2.tar.bz2
> 
> SHA1 sum: 2871d58ab1f8d5b2b8d548d57489873f21c085be
> 
> Here is the short log of the changes (since v0.9.22)
> included in this release:

This is an artifact of how I created 3.0 and 3.1, the log since 3.1 is
shorter:

Christian Lamparter (1):
      iw: fix HT PHY BSS Membership selector value encoding

Helmut Schaa (1):
      iw: show STA flags in station dump

Javier Cardona (1):
      support for setting RANN interval and mesh gate

Johannes Berg (11):
      update nl80211.h
      update nl80211.h
      print roam capability
      show supported ciphers
      print PHY membership selector only for membership rates
      SSID printing: escape space at beginning end, backslash
      print wiphy idx in iface info
      update nl80211.h
      print PMKSA candidate event
      print out AP-side uAPSD support
      update version to 3.2

Yegor Yefremov (1):
      iw: add libnl-3.0 support


johannes

