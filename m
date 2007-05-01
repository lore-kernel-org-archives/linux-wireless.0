Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbXEALr5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 07:47:57 -0400
Subject: Re: [PATCH] mac80211: mark as experimental
From: Dan Williams <dcbw@redhat.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Jiri Benc <jbenc@suse.cz>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1177969723.26986.30.camel@dv>
References: <20070430201742.1f53aa40@griffin.suse.cz>
	 <1177969723.26986.30.camel@dv>
Content-Type: text/plain
Date: Tue, 01 May 2007 07:51:11 -0400
Message-Id: <1178020272.21671.1.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-04-30 at 17:48 -0400, Pavel Roskin wrote:
> On Mon, 2007-04-30 at 20:17 +0200, Jiri Benc wrote:
> > Make the stack depend on EXPERIMENTAL. Also, change the name from "dscape"
> > to "mac80211".
> 
> Why is it needed to make mac80211 EXPERIMENTAL?  With mac80211 already
> in Ubuntu 7.04 and in the forthcoming Fedora 7, it must have received
> more testing than some drivers not marked as EXPERIMENTAL.

It's still just not there yet, especially WRT compatibility behavior for
WEXT.  I don't know if that justifies EXPERIMENTAL status, but most
drivers don't appear to be production ready, from user reports.

Dan

> I don't think enabling mac80211 per se would destabilize the kernel.
> Individual drivers could be marked experimental.  In particular,
> bcm43xx_mac80211 needs such designation, since the softmac version is
> much better currently.
> 
> If we encourage enabling mac80211, it would make it easier for the users
> to compile and test mac80211 based drivers, such as iwlwifi.  Even
> bcm43xx_mac80211 could be packaged separately to allow compilation
> against an existing kernel for the users who want to test it without
> upgrading the kernel.
> 
> In my opinion, marking mac80211 as EXPERIMENTAL would hinder testing of
> mac80211 drivers without having any positive effect on the users who
> want stability.
> 

