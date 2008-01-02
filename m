Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2238 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172AbYABSbW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 13:31:22 -0500
Date: Wed, 2 Jan 2008 13:07:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Marco =?iso-8859-1?Q?H=F6fle?= <Marco.Hoefle@web.de>,
	linux-wireless@vger.kernel.org
Subject: Re: Bug or am I too stupid for installing the Intel Wirelss
	drivers for Linux?
Message-ID: <20080102180711.GB3120@tuxdriver.com> (sfid-20080102_183143_672854_C1AC67D7)
References: <54984095@web.de> <1198855928.23441.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1198855928.23441.8.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 28, 2007 at 10:32:07AM -0500, Dan Williams wrote:

> In any case, since RHEL5 runs 2.6.18, you'll need to work a bit to
> backport mac80211 and iwl3945.  There were some heavy crypto changes
> around 2.6.18/2.6.19, and there may be quite a lot of lower level
> network stack churn that you'll have to deal with.

You might try the test kernels here:

	http://people.redhat.com/linville/kernels/rhel5/

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
