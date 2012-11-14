Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45305 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422661Ab2KNOWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 09:22:39 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi
Subject: [RFC 0/2] P2P GO powersave configuration
Date: Wed, 14 Nov 2012 15:23:09 +0100
Message-Id: <1352902991-23770-1-git-send-email-johannes@sipsolutions.net> (sfid-20121114_152243_043383_6140F190)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's some code to allow CT Window and opportunistic
PS configuration. Jouni, could you check that this looks
fine and could be used by wpa_s?

Thanks,
johannes


