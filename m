Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16521 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab1KCJvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 05:51:48 -0400
Date: Thu, 3 Nov 2011 11:49:43 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Dan Williams <dcbw@redhat.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ieee80211: Define cipher suite selector for WPI-SMS4
Message-ID: <20111103094943.GA9331@jouni.qca.qualcomm.com> (sfid-20111103_105152_679633_EA0B800E)
References: <20111102213456.GA21460@jouni.qca.qualcomm.com>
 <1320282954.20617.1.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1320282954.20617.1.camel@dcbw.foobar.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 02, 2011 at 08:15:52PM -0500, Dan Williams wrote:
> On Wed, 2011-11-02 at 23:34 +0200, Jouni Malinen wrote:
> > This value is used for WPI-SMS4 in ISO/IEC JTC 1 N 9880.
> 
> Does that mean WAPI at some point? :)

Well, I think we are getting to the point where more or less all the
needed interfaces are in place to implement this cleanly. I would assume
that some drivers have already supported this in the past, but there
must have been some hacks in place, e.g., to avoid the WPI PN
configuration that I fixed in the other patch from yesterday. There is
still a small piece needed for AP mode to indicate some events that I
hope to get submitted once I actually understand what it does ;-). In
addition, better configuration of the AKM could be useful to get added
eventually.

Johannes covered other parts of the question and I don't have
anything to add at this point.

-- 
Jouni Malinen                                            PGP id EFC895FA
