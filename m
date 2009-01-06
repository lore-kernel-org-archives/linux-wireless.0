Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:61844 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZAFIu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 03:50:28 -0500
Received: by ewy10 with SMTP id 10so8320605ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 00:50:27 -0800 (PST)
Message-ID: <eb3ff54b0901060050q2b5e46adt283bc3e032748dc4@mail.gmail.com> (sfid-20090106_095033_319563_94655170)
Date: Tue, 6 Jan 2009 10:50:27 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 0/6] mac80211: misc cleanups.
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While probing into mac80211 code, I assembelled a bunch of cleanup
patches. This patchset provides these cleanups, each one separately
(in case any of them is rejected because of some future use I am not
aware of, etc.).

(wireless-testing).

Signed-off-by: Rami Rosen <ramirose@gmail.com>
