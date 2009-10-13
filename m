Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:50467 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZJMWnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 18:43:49 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 13 Oct 2009 15:42:53 -0700
Message-ID: <43e72e890910131542k376a87c5rc30feb6491a06867@mail.gmail.com>
Subject: Stable compat-wireless 2.6.32-rc4 released
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the kernel moves along so does the automatic stable backports for
the wireless subsystem [1]. We are now on 2.6.32-rc4. Besides getting
the same fixes from rc1..rc4 some backport changes were made as well,
most importantly that of relying on your own kernel's iw_handler.h.
I've tested this release with 2.6.28.

Please report any issues you see.

[1] http://wireless.kernel.org/en/users/Download/stable

PS. If you maintain a distribution and rely on stable compat-wireless
releases please let me know so I can CC you when further updates are
made.

  Luis
