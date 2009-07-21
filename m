Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36504 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZGULrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 07:47:39 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.69)
	(envelope-from <wireless@sipsolutions.net>)
	id 1MTDop-0000kz-DX
	for linux-wireless@vger.kernel.org; Tue, 21 Jul 2009 13:47:39 +0200
To: linux-wireless@vger.kernel.org
Subject: [ANN] rfkill: v0.1
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1MTDop-0000kz-DX@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Tue, 21 Jul 2009 13:47:39 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of rfkill (v0.1) is available at:

http://wireless.kernel.org/download/rfkill/rfkill-0.1.tar.bz2

SHA1 sum: ac00cb3887641ab1048218a5979ce32243ce31d2

Here is the short log of the changes included in this 
release:

Johannes Berg -  bump version to 0.1
Johannes Berg -  check event size for version 1
Johannes Berg -  use right event size for read()
Marcel Holtmann -  open device read-only for list and event operations
Johannes Berg -  comment out rfkill manpage install for now
Johannes Berg -  add *~ to gitignore
Johannes Berg -  add .gitignore
Johannes Berg -  version script "improvement"
Marcel Holtmann -  implement basic rfkill functionality
Marcel Holtmann -  update to latest rfkill.h
Marcel Holtmann -  fix wrong rfkill_version type
Johannes Berg -  init rfkill basic code
