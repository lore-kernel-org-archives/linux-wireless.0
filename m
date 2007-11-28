Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:26552 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbXK1DPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 22:15:17 -0500
Received: by py-out-1112.google.com with SMTP id u77so2668486pyb
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 19:15:17 -0800 (PST)
Message-ID: <43e72e890711271915u53dcf9aaxa1b36b7c8bbd06a@mail.gmail.com> (sfid-20071128_031530_112986_8B50E026)
Date: Tue, 27 Nov 2007 22:15:16 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: wireless <linux-wireless@vger.kernel.org>
Subject: compat-wireless-2.6 update
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well I think this adds all new and actively patched drivers. If I
missed anyone please let me know. Not adding old softmac as that will
die very soon.

 * Adds ipw2100, ipw2200
 * Adds net/ieee80211/ for Intel's ipw drivers and libertas. This
    required porting sg_init_table().
 * I thought I had added b43legacy, I hadn't this adds it for sure
 * Update docs, added TODO list on README
 * Fix uninstall, wasn't removing all modules as claimed

TODO:

* Finish nl80211 port
* Compatibilty work for 2.6.18 --> 2.6.21 (RHEL5, Centos5, Debian etch
seem to be stuck on this kernel)
* Dialog (make menuconfig) option for this package

  Luis
