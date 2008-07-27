Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:3032 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbYG0Mrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 08:47:36 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1392033nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2008 05:47:35 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 0/3] rt2x00 update
Date: Sun, 27 Jul 2008 15:05:37 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807271505.38116.IvDoorn@gmail.com> (sfid-20080727_144746_667806_8B694108)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are 3 patches for rt2x00 intended for the 2.6.27 kernel.
It finally fixes the ifdown & ifup breakage in rt61pci, as well
as a BUG_ON() which was triggered during such an ifdown & ifup
cycle.

Ivo
