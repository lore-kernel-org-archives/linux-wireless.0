Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60438 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2BXMwL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 07:52:11 -0500
Message-Id: <20120224125050.809601111@sipsolutions.net> (sfid-20120224_135221_048798_306DEC31)
Date: Fri, 24 Feb 2012 13:50:50 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] clean up deauth/disassoc
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are a few patches to clean up the code
and flow for deauth/disassoc.

Given the auth/assoc redesign this seems much
more natural.

johannes
