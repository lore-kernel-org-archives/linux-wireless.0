Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60777 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab3ARUoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 15:44:03 -0500
Received: from wireless by sipsolutions.net with local (Exim 4.80)
	(envelope-from <wireless@sipsolutions.net>)
	id 1TwInC-0003Ys-9v
	for linux-wireless@vger.kernel.org; Fri, 18 Jan 2013 21:44:02 +0100
To: linux-wireless@vger.kernel.org
Subject: [ANN] wireless-regdb: master-2013-01-11
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1TwInC-0003Ys-9v@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Fri, 18 Jan 2013 21:44:02 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of wireless-regdb (master-2013-01-11) is available at:

http://wireless.kernel.org/download/wireless-regdb/wireless-regdb-2013.01.11.tar.bz2

SHA1 sum: 38cd3098903b8b1aa991f893d8b1fb0e068173ba


For your convenience the individual regulatory.bin file can be downloaded from:

http://wireless.kernel.org/download/wireless-regdb/regulatory.bins/2013.01.11-regulatory.bin

SHA1 sum a152577246d35299ff195dc650d1097935bda830

Here is the short log of the changes included in this 
release:

Johannes Berg (4):
      dbparse: remove usable bandwidth check
      regdb: enable HT40 on channels 8-13 in Japan
      regdb: remove unused 10 MHz wide rules for JP
      regdb: remove wrong 10 MHz rule for JP

John W. Linville (2):
      wireless-regdb: update regulatory.bin based on preceding changes.
      wireless-regdb: update regulatory.bin based on preceding changes.

Mykyta Iziumtsev (1):
      wireless-regdb: Update regulations for Ukraine

Rajkumar Manoharan (1):
      wireless-regdb: add Rwanda (RW)

Vladimir Kondratiev (3):
      wireless-regdb: add regulatory rule for US on 60gHz band
      wireless-regdb: add regulatory rule for ETSI members on 60GHz band
      wireless-regdb: add regulatory rule for China on 60GHz band

