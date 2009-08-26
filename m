Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbZHZJus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 05:50:48 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.69)
	(envelope-from <wireless@sipsolutions.net>)
	id 1MgF9S-0004j9-9D
	for linux-wireless@vger.kernel.org; Wed, 26 Aug 2009 11:50:48 +0200
To: linux-wireless@vger.kernel.org
Subject: [ANN] rfkill: v0.2
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1MgF9S-0004j9-9D@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Wed, 26 Aug 2009 11:50:46 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of rfkill (v0.2) is available at:

http://wireless.kernel.org/download/rfkill/rfkill-0.2.tar.bz2

SHA1 sum: fc8f36efd4827219ca7169f8c55572a4c9e1c3b7

Here is the short log of the changes included in this 
release:

Johannes Berg (4):
      remove iteration and let the kernel do it
      add manpage
      sync with kernel, add GPS
      version 0.2

Tim Gardner (3):
      Added a utility function to acquire a list of events.
      Added rfkill_block_all()
      Added support for block/unblock wireless types.

