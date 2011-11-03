Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57290 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab1KCWkA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 18:40:00 -0400
Received: by iage36 with SMTP id e36so1844325iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 15:40:00 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 3 Nov 2011 23:40:00 +0100
Message-ID: <CAMG6FYiNW-1ijghpgQ6R_9HujVEp8d53DQ-vjfJrw_hZamM8Jw@mail.gmail.com> (sfid-20111103_234003_916668_369EC50A)
Subject: A new driver is going to be released
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm about to release cw1200 driver to the community (more or less
latest code is available here:
http://www.igloocommunity.org/gitweb/?p=kernel/igloo-kernel.git;a=shortlog;h=refs/heads/linux-3.0-ux500
as well).

Technical question: how is it usually done in terms of commit history?
Should I preserve the history and release all the changes in the
driver separately or should I squash everything to a single commit
or...?

Thank you and with best regards,
Dmitry
