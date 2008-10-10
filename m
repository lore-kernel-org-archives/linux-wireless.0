Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:36196 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbYJJAyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 20:54:10 -0400
Message-ID: <48EEA7A4.2020303@openwrt.org> (sfid-20081010_025414_353032_3CE1E95E)
Date: Fri, 10 Oct 2008 02:53:56 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH 0/2] make b43 work with minstrel
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

here are some small patches to make b43 work properly with minstrel.
The b43 patch might need more review/testing, but it matches my
observations with a BCM4311 card. b43legacy could probably be adapted
in a similar way, but I didn't test that.

- Felix
