Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:23664 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbYHFN5v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 09:57:51 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1135892nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 06:57:49 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 0/2] rt2x00 update
Date: Wed, 6 Aug 2008 16:17:44 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808061617.44704.IvDoorn@gmail.com> (sfid-20080806_155754_854773_132FC05A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

2 small patches for on top of the pull request from a few days ago,
minor bugfix and a small optimization which is mostly important
for rt2800 later on but is usable for rt61pci and rt73usb as well.

Ivo
