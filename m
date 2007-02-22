Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:7511 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751952AbXBVVtb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Feb 2007 16:49:31 -0500
Message-ID: <45DE0F15.4000905@linux.intel.com>
Date: Thu, 22 Feb 2007 13:45:57 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: FYI - new d80211 subsystem package posted
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I posted a new legacy kernel d80211 package based on wireless-dev commit 
id 17e0264113fcf465d0712ce492c6a546d207d786.

Per the versioning scheme being used where the first digit is 
incremented with each re-base to wireless dev, this version is:

	d80211-2.0.1.tgz

You can find it (if you want it, or want to direct users to it) at

	http://intellinuxwireless.org/?p=d80211&n=downloads

There is little difference beyond compatibility patches for this version 
vs. John's tree.  I pulled out the bulk of the patches we had in 
pending/ as they don't currently apply to the rebase and I didn't want 
to delay getting this out for users.  The only patch currently applied 
is the one I emailed to the list a few hours ago making nl80211 optional 
in the build.

Beyond doing some build testing, I haven't given much testing yet to 
run-time.

Thanks,
James
