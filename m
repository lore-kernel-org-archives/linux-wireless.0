Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:48616
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039AbXBTPa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Feb 2007 10:30:56 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: Remove obsolete files
Date: Tue, 20 Feb 2007 16:30:03 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702201630.04040.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think we should do

git rm drivers/net/wireless/README
git rm drivers/net/wireless/todo.txt

in wireless-2.6, as these files only contain obsolete information.
I don't send a patch for this, as doing git-rm is easier than
handling a big ---patch

-- 
Greetings Michael.
