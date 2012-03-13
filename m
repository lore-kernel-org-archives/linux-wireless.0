Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44519 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2CMNEQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 09:04:16 -0400
Message-Id: <20120313125702.703540202@sipsolutions.net> (sfid-20120313_140421_091914_C496850A)
Date: Tue, 13 Mar 2012 13:57:02 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] BSS timestamp fix/cleanup
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was looking at this code and thought I'd clarify it
and remove some abuse in brcmfmac.

johannes
