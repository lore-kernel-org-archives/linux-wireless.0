Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab0BFOig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2010 09:38:36 -0500
Received: from wireless by sipsolutions.net with local (Exim 4.71)
	(envelope-from <wireless@sipsolutions.net>)
	id 1Ndlnt-0005DG-V9
	for linux-wireless@vger.kernel.org; Sat, 06 Feb 2010 15:38:34 +0100
Date: Sat, 06 Feb 2010 15:38:33 +0100
Message-Id: <E1Ndlnt-0005DG-V9@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [ANN] rfkill: v0.4
Reply-to: linux-wireless@vger.kernel.org
From: wireless@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of rfkill (v0.4) is available at:

http://wireless.kernel.org/download/rfkill/rfkill-0.4.tar.bz2

SHA1 sum: fccabf5a272ac2891f24dc35449dc6f4c45ff44b

Here is the short log of the changes included in this 
release:

Darren Salt (10):
      Move the man page to section 8
      Add "wlan" and "ultrawideband" as aliases for "wifi" and "uwb".
      Rearrange the help text for block & unblock.
      Constification.
      Return error codes instead of exiting.
      Refactor rfkill index/type lookup: move it below rfkill_block.
      Add filtering to "rfkill list".
      Tweak version handling to allow vendor-specific suffixes without patching.
      Help text: output rfkill type names from an array instead of a static string.
      Add rfkill type "fm" to the man page.

Johannes Berg (4):
      flush output after events
      print time instead of useless text
      change manpage for new rfkill list behaviour
      version 0.4

John W. Linville (1):
      default install to $(PREFIX)/sbin

Tomas Winkler (1):
      update rfkill.h from kernel 2.6.33

