Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.polymtl.ca ([132.207.4.11]:60077 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966019Ab2B2ScZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 13:32:25 -0500
Received: from localhost (imp-4-2.polymtl.ca [132.207.4.77])
	by smtp.polymtl.ca (8.14.3/8.14.3) with ESMTP id q1TILp0U002426
	for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 13:21:51 -0500
Message-ID: <1330539711.4f4e6cbf1924d@www.imp.polymtl.ca> (sfid-20120229_193229_020249_98DAB969)
Date: Wed, 29 Feb 2012 13:21:51 -0500
From: Naveen Goswamy <naveen.goswamy@polymtl.ca>
To: linux-wireless@vger.kernel.org
Subject: brcmsmac not working well
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, I've tested brcmsmac in 3.2 and 3.3, and it really is not stable enough to
use for me.  I have the BCM4313 [14e4:4727] (rev 01)

One noticeable problem is trying to SSH is nearly impossible (including sftp and
sshfs mounting).  Also web browsing slows to a crawl and eventually tanks.

I'd like to know how to debug this, and if there are any known issues.

TIA,

ng




