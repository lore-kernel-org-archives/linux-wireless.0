Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758192Ab2EKIx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 04:53:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: iwlwifi updates 2012-05-11
Date: Fri, 11 May 2012 10:53:14 +0200
Message-Id: <1336726398-13200-1-git-send-email-johannes@sipsolutions.net> (sfid-20120511_105351_640165_E92514B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are some more iwlwifi updates :-)

David Spinadel worked on scanning and got rid of the extra
wildcard probe. This is at the expense of some probe request
IE space, but due to the sizing bug that he also fixed the
IE space was previously actually advertised wrongly, we'd
already fail at 40 bytes less than advertised.

I also include a patch to make use of the explicit monitor
interface to use sniffer mode and hopefully keep injection
working with the HW queue changes.

johannes

