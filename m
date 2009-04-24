Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:39348 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbZDXSFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 14:05:25 -0400
Received: by ey-out-2122.google.com with SMTP id 9so289810eyd.37
        for <linux-wireless@vger.kernel.org>; Fri, 24 Apr 2009 11:05:23 -0700 (PDT)
Date: Fri, 24 Apr 2009 21:05:07 +0300
From: Kadianakis George <desnacked@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, flamingice@sourmilk.net
Subject: mac80211 and hidden ESSIDs in 2.6.28
Message-ID: <20090424180506.GA6026@grayskull> (sfid-20090424_200529_204172_7D6B8DAD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings,

this bug: http://bugs.gentoo.org/show_bug.cgi?id=262862 seems to
reveal a bug in mac80211 being unable to handle APs that don't
broadcast their ESSIDs.

The issue appeared in the 2.6.28 versions (2.6.27 worked alright) of
the Linux kernel and it seems to be fixed in 2.6.29.

A bugzilla entry for this specific bug was created over here: 
http://bugs.gentoo.org/show_bug.cgi?id=267368

Any ideas on what caused it and which patch fixed it?

Thanks
