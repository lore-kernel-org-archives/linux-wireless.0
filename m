Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:4514 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966246Ab3DQMH0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 08:07:26 -0400
From: stf_xl@wp.pl
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH v2 00/11] rt2800: cleanup rfcsr init procedures
Date: Wed, 17 Apr 2013 14:08:09 +0200
Message-Id: <1366200500-4661-1-git-send-email-stf_xl@wp.pl> (sfid-20130417_140745_480206_D6FD11F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v1 -> v2:
- address comments from Gabor Juhos and Gertjan van Wingerde
- rebase on top of "Fix transmit power troubles on some Ralink
  RT30xx cards" patch

