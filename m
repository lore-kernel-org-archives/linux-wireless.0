Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:48215 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab0LXCIs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 21:08:48 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PVx5L-00021j-E8
	for linux-wireless@vger.kernel.org; Fri, 24 Dec 2010 03:08:47 +0100
Received: from ool-4a5955a5.dyn.optonline.net ([74.89.85.165])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 Dec 2010 03:08:47 +0100
Received: from erappleman by ool-4a5955a5.dyn.optonline.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 Dec 2010 03:08:47 +0100
To: linux-wireless@vger.kernel.org
From: Eric Appleman <erappleman@gmail.com>
Subject: Re: iwlwifi: Intel 3945ABG speed issues finally identified.
Date: Fri, 24 Dec 2010 02:08:36 +0000 (UTC)
Message-ID: <loom.20101224T030743-87@post.gmane.org>
References: <loom.20101223T071403-99@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmmm.

Both "fix internal scan" and "stuck queue detection" made the cut for the rc2
kernel. Said kernel is unaffected by the bug.

For rc3, "rcu lock" and "move sysfs" both make the cut. "serialize station
management" barely misses the cut.

Does the sysfs commit apply to the 3945 or is it only for newer cards?

