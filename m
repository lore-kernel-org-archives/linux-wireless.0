Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48117 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbcEKCFX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 22:05:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1b0JWK-0000Z3-7L
	for linux-wireless@vger.kernel.org; Wed, 11 May 2016 04:05:15 +0200
Received: from 223.87.33.0 ([223.87.33.0])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2016 04:05:04 +0200
Received: from lgkbiti by 223.87.33.0 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2016 04:05:04 +0200
To: linux-wireless@vger.kernel.org
From: andy <lgkbiti@163.com>
Subject: wifi driver crashes openwrt device
Date: Tue, 10 May 2016 15:17:25 +0000 (UTC)
Message-ID: <loom.20160510T171307-937@post.gmane.org> (sfid-20160511_040530_120440_ADE7B250)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello, every body.
  I developed an openwrt device based on git clone 
git://git.openwrt.org/15.05/openwrt.git.
  I found that my device rebooted during wifi initializing sometimes, maybe 
one in twenty. 
  The wifi driver is compat-wireless-2016-01-10.tar.bz2.
  Could somebody give some hint or help me to resolve this wired issue?
  Thank you very much.

