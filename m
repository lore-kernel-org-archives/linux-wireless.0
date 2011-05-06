Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:34080 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab1EFFgC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 01:36:02 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-66-79-239-161.nexicom.net [66.79.239.161])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p465Qq6r015772
	for <linux-wireless@vger.kernel.org>; Fri, 6 May 2011 01:26:55 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id F29961E015F
	for <linux-wireless@vger.kernel.org>; Fri,  6 May 2011 01:26:51 -0400 (EDT)
Message-ID: <4DC386BB.4010106@lockie.ca> (sfid-20110506_073608_690055_DB9CAF18)
Date: Fri, 06 May 2011 01:27:23 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: scan not working or limited
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I get the errors:
ath: Failed to stop TX DMA in 100 msec after killing last frame
ath: Failed to stop TX DMA!
on all the kernels that my scans don't work right.

I did:
$ git clone
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
$ cd linux-2.6.37.y
$ git bisect start
$ git bisect good v2.6.36
$ git bisect bad v2.6.37.6
It said 3044100e58c84e133791c8b60a2f5bef69d732e4 is the first bad commit.

I typed that number. :-(
How do I make git print it again?
How do I find the details of that commit?
How do I reverse what that commit did?

