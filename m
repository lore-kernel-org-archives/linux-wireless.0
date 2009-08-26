Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49117 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557AbZHZJun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 05:50:43 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.69)
	(envelope-from <wireless@sipsolutions.net>)
	id 1MgF9P-0004iG-8h
	for linux-wireless@vger.kernel.org; Wed, 26 Aug 2009 11:50:44 +0200
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v0.9.17
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1MgF9P-0004iG-8h@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Wed, 26 Aug 2009 11:50:43 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v0.9.17) is available at:

http://wireless.kernel.org/download/iw/iw-0.9.17.tar.bz2

SHA1 sum: ca2afc3cdf553a9231fcd7ad59e74cf964fb4b9d

Here is the short log of the changes included in this 
release:

Arnd Hannemann (1):
      fix output qualifier for unsigned values

Holger Schurig (1):
      don't emit usage to stderr

Johannes Berg (3):
      also fix %d -> %u for 'iw link'
      separate commands into sections
      0.9.17

