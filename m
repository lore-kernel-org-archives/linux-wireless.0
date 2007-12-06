Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:38474 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbXLFXGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 18:06:48 -0500
Received: by py-out-1112.google.com with SMTP id u77so959253pyb
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2007 15:06:48 -0800 (PST)
Message-ID: <43e72e890712061506s19408190y85223ddc1b8225b5@mail.gmail.com> (sfid-20071206_230653_309214_7633AFCB)
Date: Thu, 6 Dec 2007 18:06:47 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: ath5k automated kerneldoc output - updated nightly
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, ath5k now has posted HTML kerneldocs, updated nightly:

http://linuxwireless.org/en/users/Drivers/ath5k#ath5kkerneldoc

We only have kerneldoc with actual content for ath5k.h, debug.h, hw.c
and phy.c. This is still pretty minimal. If you are helping with the
driver I'd like to request to consider adding kdoc through things you
think might be helpful as you go on hacking the driver to help
development documentation. I'll try to get started on a format for
reg.h.

  Luis
