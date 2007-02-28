Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-67.dex002.intermedia.net ([64.78.20.25]:37146 "EHLO
	DHOST002-67.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932374AbXB1TWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 14:22:07 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Wed, 28 Feb 2007 11:21:47 -0800
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Larry Finger <larry.finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Alex Davis <alex14641@yahoo.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Patch to allow specification of interface name prefix
Message-ID: <20070228192147.GE31074@devicescape.com>
References: <510326.55988.qm@web50211.mail.yahoo.com> <20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net> <45E112F7.9090908@lwfinger.net> <20070226150241.1b5b63b2@freekitty> <20070227111644.784600be@logostar.upir.cz> <43e72e890702271055sc1525ecy54870626125a7fae@mail.gmail.com> <20070228012500.GB4072@tuxdriver.com> <20070228164437.GA31074@devicescape.com> <20070228183535.GB5353@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070228183535.GB5353@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 28, 2007 at 01:35:35PM -0500, John W. Linville wrote:
> On Wed, Feb 28, 2007 at 08:44:37AM -0800, Jouni Malinen wrote:
> > Why would we need to change anything now? What's wrong with wlan#?
> 
> See the earlier parts of the thread... :-)

I've seen a somewhat vague comment about some sort of decision on this
front, but no one seems to be able to point to any level of details on
what was agreed on and if yes, when and by whom. I have seen number of
discussions on the topic of what the interfaces should be named, but
none of those seem to be going anywhere and I have not seen any
consensus on this topic. As such, the best thing to do seems to be not
to do anything, i.e., not rename wlan# to anything else. If someone
claims that d80211 is changing the existing behavior, I would just like
to point out that wlan# is already used in the current mainline kernel
and that argument does not sound reasonable.

-- 
Jouni Malinen                                            PGP id EFC895FA
