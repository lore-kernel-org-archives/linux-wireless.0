Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZDRDKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 23:10:10 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.69)
	(envelope-from <wireless@sipsolutions.net>)
	id 1Lv0wS-0000ZC-06
	for linux-wireless@vger.kernel.org; Sat, 18 Apr 2009 05:10:08 +0200
To: linux-wireless@vger.kernel.org
Subject: [ANN] crda: v1.0.2
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1Lv0wS-0000ZC-06@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Sat, 18 Apr 2009 05:10:08 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of crda (v1.0.2) is available at:

http://wireless.kernel.org/download/crda/crda-1.0.2.tar.bz2

SHA1 sum: 77d403d97fd7e7647778f8c121a1cb46dc47bb77

Here is the short log of the changes included in this 
release:

Luis R. Rodriguez -  Allow distributions to specify a custom pubkeys dir
Luis R. Rodriguez -  Doh, forgot to add crda after SBINDIR
Luis R. Rodriguez -  Add comments to explain paths
Luis R. Rodriguez -  Add /usr/local/lib/crda/regulatory.bin as first in path
Helmut Schaa -  crda: allow loading of regulatory.bin from /lib/crda in addition to /usr/lib/crda
Luis R. Rodriguez -  Fix Makefile to not overwrite udev/regulatory.rules for SBINDIR changes
Daniel Mierswa -  also replace the SBINDIR used in the rules file
Daniel Mierswa -  use SBINDIR in install target of CRDA
Pat Erley -  crda: rename nl_handle to nl_sock for libnl-2.0
Pavel Roskin -  crda: report if no supported version of libnl is found
Luis R. Rodriguez -  Update debian example changelog
Luis R. Rodriguez -  Updates spec file version
