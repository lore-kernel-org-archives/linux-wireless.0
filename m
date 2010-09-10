Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45505 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab0IJRtT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 13:49:19 -0400
Received: by iwn5 with SMTP id 5so2399582iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Sep 2010 10:49:18 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 10 Sep 2010 10:48:58 -0700
Message-ID: <AANLkTikAzX61npZ0WdzbqNoftaugwkL6H1w1A4ofAQMJ@mail.gmail.com>
Subject: Wireles-regdb mailing list / process for changes
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Green <Michael.Green@atheros.com>,
	David Quan <David.Quan@atheros.com>,
	Amod Bodas <Amod.Bodas@atheros.com>,
	Cliff Holden <Cliff.Holden@atheros.com>,
	Kathy Giori <Kathy.Giori@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As discussed at the 2010 San Francisco Linux wireless summit [0]
please subscribe to the wireless-regdb mailing list [1] and/or ask
your own company regulatory experts willing to help to do the same to
help chime in in helping the community enhance the wireless-regdb. All
cfg80211 drivers will get benefit from this. You can view database
online via the webiew [2] or the direct git repository [3].

It seems the agreeable procedure moving forward is to send patches
there and those who want to help review or *have* to review will help
in reviewing the patches.

Moving forward, you are expected to at least provide some references
if possible to regulatory documentation. At times it may not be
possible to refer to the regulatory documentation due to copyright
concerns over those documents. Rule of thumb is do what you can to
help document regulatory changes.

A good example of a patch:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-regdb.git;a=commitdiff;h=fcbf9225d56e82d9a4e506187d42285e76d81523;hp=24b40af7f478b4a67343ee3543570f60b6bedf1f

If you want to point out references directly from the webview you can
embed your references through comments, for example:

http://wireless.kernel.org/en/developers/Regulatory/Database?alpha2=DE

A bad example of a patch:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-regdb.git;a=commitdiff;h=6dcc5d7b02011ef3ef1f40163309911b5e92c4c8;hp=17d3d13641c021deaa4d4d2a3523a7f54133738b

  Luis

[0] http://wireless.kernel.org/en/developers/Summits/SanFranciscoBayArea-2010
[1] http://lists.infradead.org/mailman/listinfo/wireless-regdb
[2] http://wireless.kernel.org/en/developers/Regulatory/Database
[3] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-regdb.git

  Luis
