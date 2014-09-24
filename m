Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 6.mo68.mail-out.ovh.net ([46.105.63.100]:48934 "EHLO
	mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751753AbaIXRhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 13:37:48 -0400
Received: from mail440.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo68.mail-out.ovh.net (Postfix) with SMTP id 0BB07FFBB18
	for <linux-wireless@vger.kernel.org>; Wed, 24 Sep 2014 19:19:09 +0200 (CEST)
Received: from po57.wetron.local (83.pool85-58-156.dynamic.orange.es [85.58.156.83])
	by ventoso.org (Postfix) with ESMTPSA id 2149244C5B
	for <linux-wireless@vger.kernel.org>; Wed, 24 Sep 2014 19:19:08 +0200 (CEST)
Message-ID: <5422FD0B.3060806@ventoso.org> (sfid-20140924_193752_339482_4676C729)
Date: Wed, 24 Sep 2014 19:19:07 +0200
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Mediatek MT7601U big endian fixes
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

apart from the general brokenness of the vendor supplied driver (see
http://www.spinics.net/lists/linux-wireless/msg126291.html and
http://www.arnelborja.com/compiling-rt2870-wifi-driver-in-fedora/), it
doesn't work in big endian mode.

Without this patch:

https://code.google.com/p/mt7601-openwrt/source/browse/patches/007-big-endian-fix.patch

it doesn't even compile, and this one

https://code.google.com/p/mt7601-openwrt/source/browse/patches/008-more-big-endiand-fixes.patch

makes it functional.

Before finding the fix myself I contacted mediatek support with no reply
so far.

Do you know if is there somebody (at ralink/mediatek or elsewhere)
working on integrating this chipset in the in-kernel driver?

Bye
-- 
Luca
