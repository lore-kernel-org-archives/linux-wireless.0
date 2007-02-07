Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3470 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965632AbXBGBOI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 20:14:08 -0500
Received: from ra.tuxdriver.com (ra.tuxdriver.com [127.0.0.1])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l171DuDE003162
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 6 Feb 2007 20:14:02 -0500
Received: (from uucp@localhost)
	by ra.tuxdriver.com (8.13.7/8.13.6/Submit) with UUCP id l1719lUV003141
	for linux-wireless@vger.kernel.org; Tue, 6 Feb 2007 20:09:47 -0500
Received: from linville-t43.mobile (linville-t43.mobile [127.0.0.1])
	by linville-t43.mobile (8.13.8/8.13.8) with ESMTP id l1718AkR023712
	for <linux-wireless@vger.kernel.org>; Tue, 6 Feb 2007 20:08:10 -0500
Received: (from linville@localhost)
	by linville-t43.mobile (8.13.8/8.13.8/Submit) id l1718Aaw023711
	for linux-wireless@vger.kernel.org; Tue, 6 Feb 2007 20:08:10 -0500
Date: Tue, 6 Feb 2007 20:08:10 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: wireless-dev rebase (prep for -mm)
Message-ID: <20070207010810.GE23096@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case anyone doesn't know, wireless-dev is here:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.git

As I mentioned in London, I have kept this tree current w/ Linus by
pulling from his branch into the master merge branch.  This has some
advantages for my immediate downstream driver maintainers, but it
has disadvantages.  In particular, it makes it difficult to extract
a patch stream from wireless-dev that will directly apply on top of
a current tree from Linus, et al.

I have taken some time and applied some git foo so that now I have a
branch ("mm-master") that can yield such a patch stream.  This branch
will be the base from which I will ask akpm to pull from -mm.
It is rooted on top of the "cfg80211" branch, which contains the
cfg80211 patches that I am grooming for an upstream merge in the
immediate future.  For now, I will also continue to maintain the
"master" branch as I have done previously.

This message is intended to keep everyone who cares "in the loop".
Feel free to voice any concerns/complaints/suggestions.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
