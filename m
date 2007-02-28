Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-19.dex002.intermedia.net ([64.78.21.85]:39446 "EHLO
	dhost002-19.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752265AbXB1Qox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 11:44:53 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Wed, 28 Feb 2007 08:44:37 -0800
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Larry Finger <larry.finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Alex Davis <alex14641@yahoo.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Patch to allow specification of interface name prefix
Message-ID: <20070228164437.GA31074@devicescape.com>
References: <510326.55988.qm@web50211.mail.yahoo.com> <20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net> <45E112F7.9090908@lwfinger.net> <20070226150241.1b5b63b2@freekitty> <20070227111644.784600be@logostar.upir.cz> <43e72e890702271055sc1525ecy54870626125a7fae@mail.gmail.com> <20070228012500.GB4072@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070228012500.GB4072@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 27, 2007 at 08:25:00PM -0500, John W. Linville wrote:

> Hopefully wmaster will fall off the user's radar soon.  Regarding the
> current wlanX interfaces, most modes will be using ethernet framing,
> so maybe ethX is fine.

Why would we need to change anything now? What's wrong with wlan#?

-- 
Jouni Malinen                                            PGP id EFC895FA
