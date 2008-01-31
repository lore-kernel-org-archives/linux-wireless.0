Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156AbYBAMJm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:09:42 -0500
Message-Id: <20080131184819.103174000@sipsolutions.net> (sfid-20080201_120946_048742_CB27EDE8)
Date: Thu, 31 Jan 2008 19:48:19 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/8] AP mode is coming
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches do some cleanups and introduce new features that
are the last major features for AP mode. Still missing are many
things for basic rate and ERP feature handling, so I'm still
holding back the patch that actually enables AP mode---I want
the code to be at least mostly 802.11 compliant before I allow
that.

johannes
