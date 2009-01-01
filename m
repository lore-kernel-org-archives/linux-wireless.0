Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:45937 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbZAABBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 20:01:48 -0500
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/3] p54: p54spi driver
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>
From: Christian Lamparter <chunkeey@web.de>
Date: Thu, 1 Jan 2009 02:01:43 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901010201.44229.chunkeey@web.de> (sfid-20090101_020153_090476_280B3853)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series introduce the back-end driver p54spi for stlc4550/stlc4560 chips.

So far no one complained about the patches or had any other issues...
=> therefore it must be 100% working!

[Please mind the logic gap ;-) , But I hope someone will respond
when the whole driver can be easily built with compat-wireless.]

Regards,
	Chr
