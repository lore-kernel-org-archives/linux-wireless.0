Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:43121 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbZE2TTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 15:19:34 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MA7c6-0000QL-Et
	for linux-wireless@vger.kernel.org; Fri, 29 May 2009 19:19:34 +0000
Received: from cac94-1-81-57-151-96.fbx.proxad.net ([81.57.151.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 29 May 2009 19:19:34 +0000
Received: from castet.matthieu by cac94-1-81-57-151-96.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 29 May 2009 19:19:34 +0000
To: linux-wireless@vger.kernel.org
From: Matthieu CASTET <castet.matthieu@free.fr>
Subject: b43 vs b43legacy
Date: Fri, 29 May 2009 19:19:23 +0000 (UTC)
Message-ID: <loom.20090529T190620-42@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

what's the difference between b43 and b43legacy ?

>From a first point a view, it seems b43 is for core >= 5 and b43legacy for the
other.
There is also firmware difference : b43 need v4 and b43legacy need v3.

But v4 firmware seems to support core 4 (pcm4 & ucode4) and b43 code got some
support for old chips (<5).

Is the split was made because nobody know how to use firmware v4 with core 4 or
because core 4 it so different from newer core.
In the latter case why code for older chip (<5) is not removed from the driver ?


Thanks

Matthieu

PS : sorry if the answer is already available on internet, I try to search it
without finding anything.

