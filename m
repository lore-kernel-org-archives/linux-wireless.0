Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48635 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446AbXB1OHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:18 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562562nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:17 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 19/28] rt2x00: Code cleanup after rt2x00lib
Date: Wed, 28 Feb 2007 15:07:09 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.09669.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Start using rt2x00lib, this removes quite a lot of code.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

http://www.mendiosus.nl/rt2x00/19_rt2x00_cleanup.diff
