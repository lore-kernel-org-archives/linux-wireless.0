Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3498 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129AbYDUSCg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 14:02:36 -0400
Date: Mon, 21 Apr 2008 13:41:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-wireless@vger.kernel.org, dcbw@redhat.com
Subject: Re: iwl4965: slow scans
Message-ID: <20080421174122.GA10857@tuxdriver.com> (sfid-20080421_200326_781511_4C3526F4)
References: <20080421160318.GA19802@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080421160318.GA19802@phobos.i.cabal.ca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 21, 2008 at 12:03:18PM -0400, Kyle McMartin wrote:

> I've noticed recently in rawhide that scanning for networks when I come
> back from suspend takes an age. It seems to be upwards of 3~4 minutes
> before I'm able to reassociate with my ap.
> 
> I'm pulling a pile of rpms to figure out when the change to
> linux-2.6-wireless*.patch might have caused this (it doesn't *seem* to
> happen on upstream, but since the patch might make it to upstream soon,
> I figured I should keep linux-wireless@ in the loop.)
> 
> Willing to bash on whatever I need to to improve this.

Sounds like the issue here:

	https://bugzilla.redhat.com/show_bug.cgi?id=441819

Perhaps you could post some iwevent info as Dan requested there as well?

John
-- 
John W. Linville
linville@tuxdriver.com
