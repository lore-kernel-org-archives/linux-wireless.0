Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab2EPUtx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:49:53 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] iwlwifi fixes for wireless-next
Date: Wed, 16 May 2012 22:49:46 +0200
Message-Id: <1337201389-21553-1-git-send-email-johannes@sipsolutions.net> (sfid-20120516_224957_697708_390C31F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Sorry, I should've sent these together with the printf fixes
since they're all based on wireless-next anyway.

These are a few fixes I that should go into wireless-next or
into wireless after the merge window closes.

The first patch removes some code and a Kconfig option that we
introduced recently but aren't actually using yet. Instead of
just removing the option, I'm removing all of it since it's
also unfinished code.

The second patch avoids sending a command when it's guaranteed
to fail.

The third patch fixes a memory leak in the unlikely case that
some initialization fails.

Thanks,
Johannes

