Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-77.dex002.intermedia.net ([64.78.20.107]:40306 "EHLO
	DHOST002-77.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933076AbXB1Q4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 11:56:23 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Wed, 28 Feb 2007 08:55:51 -0800
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Larry Finger <larry.finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Alex Davis <alex14641@yahoo.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Patch to allow specification of interface name prefix
Message-ID: <20070228165551.GC31074@devicescape.com>
References: <510326.55988.qm@web50211.mail.yahoo.com> <20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net> <45E112F7.9090908@lwfinger.net> <20070226150241.1b5b63b2@freekitty> <20070227111644.784600be@logostar.upir.cz> <43e72e890702271055sc1525ecy54870626125a7fae@mail.gmail.com> <20070228012500.GB4072@tuxdriver.com> <20070228164437.GA31074@devicescape.com> <1172681452.5015.41.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1172681452.5015.41.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 28, 2007 at 05:50:52PM +0100, Johannes Berg wrote:
> On Wed, 2007-02-28 at 08:44 -0800, Jouni Malinen wrote:
> > What's wrong with wlan#?
> 
> Some people are anal about changing user-visible properties when one
> driver replaces another.

So? Some drivers in the current mainline kernel are using wlan#.

-- 
Jouni Malinen                                            PGP id EFC895FA
