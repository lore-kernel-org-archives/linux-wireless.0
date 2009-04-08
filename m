Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52921 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbZDHMkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 08:40:23 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.69)
	(envelope-from <wireless@sipsolutions.net>)
	id 1LrX4n-0007Z2-7S
	for linux-wireless@vger.kernel.org; Wed, 08 Apr 2009 14:40:21 +0200
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v0.9.12
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1LrX4n-0007Z2-7S@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Wed, 08 Apr 2009 14:40:21 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v0.9.12) is available at:

http://wireless.kernel.org/download/iw/iw-0.9.12.tar.bz2

SHA1 sum: f5368cab668e3b22364b33f8a56f53e3a96041fc

Here is the short log of the changes included in this 
release:

Johannes Berg -  bump version to 0.9.12
Johannes Berg -  add plain "scan" command that triggers, waits and dumps
Johannes Berg -  allow netlink-less commands and section commands with subsections
Johannes Berg -  remove "raw" thing
Johannes Berg -  add functionality to wait for events
Johannes Berg -  prepare for more generic commands
Johannes Berg -  clean up usage code
Johannes Berg -  reorder includes
