Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43778 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbZCFBqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 20:46:51 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 17:46:50 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 0/2] wireless-regdb: Enhance world roaming
Date: Thu, 5 Mar 2009 17:46:07 -0800
Message-ID: <1236303969-22454-1-git-send-email-lrodriguez@atheros.com> (sfid-20090306_024654_959607_38AF721F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

here is a resend of my previous 5 GHz patch +
a new 2 GHz patch for channels 12-14 to enhance world
roaming operation.

Luis R. Rodriguez (2):
  wireless-regdb: enable 5 GHz world roaming
  wireless-regdb: allow passive scan on Channels 12-14

 db.txt |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

