Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:43514 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754339AbZAHLd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 06:33:28 -0500
Message-Id: <20090108113158.681894124@atheros.com> (sfid-20090108_123334_164223_0B9263EF)
Date: Thu, 08 Jan 2009 13:31:58 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv2 00/16] mac80211: IEEE 802.11w (management frame protection)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches adds support for IEEE 802.11w (management frame
protection) into mac80211. It is up-to-date with the latest IEEE 802.11w
draft (D7.0) and I do not expect any major changes to IEEE 802.11w
anymore.

This version is ready to be applied into wireless-testing. It is against
wireless-testing + CSA patch from Sujith + PS patches from Johannes.

Differences to PATCH v1:
- introduce a mechanism for drivers to indicate that they are MFP capable
  and allow user space programs to figure out whether MFP can be used
- mark ath9k MFP capable
- mark mac80211_hwsim MFP capable
- rebase against PS patches from Johannes (one of them allocated a new
  driver hw flag that would have conflicted with an allocation for MFP)

-- 
Jouni Malinen                                            PGP id EFC895FA
