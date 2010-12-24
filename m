Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:55484 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab0LXWOH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Dec 2010 17:14:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PWFtl-0004zP-JJ
	for linux-wireless@vger.kernel.org; Fri, 24 Dec 2010 23:14:05 +0100
Received: from ool-4a5955a5.dyn.optonline.net ([74.89.85.165])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 Dec 2010 23:14:05 +0100
Received: from erappleman by ool-4a5955a5.dyn.optonline.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 Dec 2010 23:14:05 +0100
To: linux-wireless@vger.kernel.org
From: Eric Appleman <erappleman@gmail.com>
Subject: Re: iwlwifi: Intel 3945ABG speed issues finally identified.
Date: Fri, 24 Dec 2010 22:13:53 +0000 (UTC)
Message-ID: <loom.20101224T222002-889@post.gmane.org>
References: <loom.20101223T071403-99@post.gmane.org>  <loom.20101224T030743-87@post.gmane.org> <1293208648.3997.54.camel@wwguy-huron>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So, unless I find something between 2.6.34 release and 2.6.35-rc2 (no changes
between rc1 and rc2), that leaves "fix internal scan", doesn't it?

Btw, this bug is ridiculously hard to test. The early rc kernels for 2.6.35 are
a pain in the ass to test because the iwl3945 driver was in flux at the time. If
I push too hard with speedtests, the driver will cause a kernel panic.

