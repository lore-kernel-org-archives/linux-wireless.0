Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47692 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbZCPVjm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 17:39:42 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.69)
	(envelope-from <wireless@sipsolutions.net>)
	id 1LjKX5-0005Pk-03
	for linux-wireless@vger.kernel.org; Mon, 16 Mar 2009 22:39:39 +0100
To: linux-wireless@vger.kernel.org
Subject: [ANN] wireless-regdb: master-2009-03-09
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1LjKX5-0005Pk-03@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Mon, 16 Mar 2009 22:39:39 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of wireless-regdb (master-2009-03-09) is avilable at:

http://wireless.kernel.org/download/wireless-regdb/wireless-regdb-2009.03.09.tar.bz2

SHA1 sum: f823eeb0c637fee9c705fc7112b33fc9eb55fa4a


For your convenience the individual regulatory.bin file can be downloaded from:

http://wireless.kernel.org/download/wireless-regdb/regulatory.bins/2009.03.09-regulatory.bin

SHA1 sum 806e601639894ce7ee01272ad0cdb4473abf7cff

Here is the short log of the changes included in this 
release:

John W. Linville -  wireless-regdb: update regulatory.bin based on preceding changes.
John W. Linville -  Remove unnecessary specification of owner and group information in install commands.  This is troublesome for non-root build environments.
John W. Linville -  Implement simple changes to dbparse.py as suggested by Julian Calaby <julian.calaby@gmail.com> in email to linux-wireless on 6 March 2009.
Luis R. Rodriguez -  wireless-regdb: sanity checks on freq range
Luis R. Rodriguez -  wireless-regdb: enable passive scanning for world regdomain on other channels
Daniel Mierswa -  CDRA_PATH typo, also let user override CRDA_PATH

This is an automatigically generated message, please only reply to the linux-wireless mailing list.
