Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47586 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab2ASIbh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jan 2012 03:31:37 -0500
Message-Id: <20120119082956.486569312@sipsolutions.net> (sfid-20120119_093141_335208_48231D08)
Date: Thu, 19 Jan 2012 09:29:56 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] per interface configuration
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We may need these features to be per interface
in the future due to uCode limitations, so let
the driver manage the flags per interface. We
can move more flags over as needed/appropriate.

johannes
