Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:7816 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbZASLuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 06:50:12 -0500
Received: by nf-out-0910.google.com with SMTP id d3so404995nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 03:50:11 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 19 Jan 2009 13:50:11 +0200
Message-ID: <eb3ff54b0901190350p29e1317k954347ef259825ed@mail.gmail.com> (sfid-20090119_125018_460901_A1BD0C3A)
Subject: [PATCH 0/4] mac80211: misc cleanups (MESH).
From: Rami Rosen <ramirose@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	luisca@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While probing into mac80211 MESH code, I assembled a bunch of cleanup patches.
This patchset provides these cleanups, each one separately (in case
any of them is rejected because of some future use I am not aware of, etc.).

Signed-off-by: Rami Rosen <ramirose@gmail.com>

--
(wireless-testing)
