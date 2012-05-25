Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37924 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758363Ab2EYUJH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 16:09:07 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Fri, 25 May 2012 13:08:46 -0700
Message-ID: <CAB=NE6Urc0LPLP87rH6sDRsaKxb8Mh9u+suWQff6X3T2mYWx1A@mail.gmail.com> (sfid-20120525_220929_806559_93302552)
Subject: [ANN] QCA swiss army knife
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org,
	qca-linux-team <qca-linux-team@qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To help with simplifying placement of userspace tool development for
QCA for our different drivers we have merged together a few public
development repositories into one, a qca-swiss-army-knife:

Code: git://github.com/mcgrof/qca-swiss-army-knife.git
Wiki: https://github.com/mcgrof/qca-swiss-army-knife/wiki

Of most importance so far is the initval-tools [0], if you used to
send patches for this utility please update your git tree to point to
this new URL, a simple change in the name should let you git pull all
the new changes, you will not have to reset your tree. The other tools
that merged into this tree were  ath-utils and hal-reg-dump, so I've
nuked the old trees from github.

If you have any question please let us know.

[0] http://wireless.kernel.org/en/users/Drivers/ath9k_hw/initvals-tool

  Luis
