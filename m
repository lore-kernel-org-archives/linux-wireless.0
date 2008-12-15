Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:53079 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYLOG7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 01:59:41 -0500
Received: by ewy10 with SMTP id 10so2850160ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 14 Dec 2008 22:59:39 -0800 (PST)
Message-ID: <eb3ff54b0812142259u576c3430x3ffd3d6c3890a9e@mail.gmail.com> (sfid-20081215_075945_138575_ED0F9A71)
Date: Mon, 15 Dec 2008 08:59:39 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 0/2] iwlwifi: misc cleanups.
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While probing into iwlwifi code, I encountered some code which can be
cleaned up.
This patchset provides these cleanups.

(wireless-testing).

Signed-off-by: Rami Rosen <ramirose@gmail.com>
