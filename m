Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:41851 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918AbYBYWYE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 17:24:04 -0500
Received: by ug-out-1314.google.com with SMTP id z38so998790ugc.16
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 14:24:02 -0800 (PST)
To: linville@tuxdriver.com
Subject: Please pull 'upstream' branch of rt2x00
Date: Mon, 25 Feb 2008 23:20:11 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802252320.11809.IvDoorn@gmail.com> (sfid-20080225_222409_682179_B1225238)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the 2.1.3 release of rt2x00.
Most bugfixes concentrate on the link tuner issues reported for
the rt2x00 2.0.14 version inside kernel 2.6.25.
One additional fix for rt61pci is present where the recent
"mode->band" changes in mac80211 contained a bug for rt61pci.

Ivo
