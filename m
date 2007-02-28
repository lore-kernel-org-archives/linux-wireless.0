Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3917 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932359AbXB1TGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 14:06:39 -0500
Date: Wed, 28 Feb 2007 13:35:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jouni Malinen <jkm@devicescape.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Larry Finger <larry.finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Alex Davis <alex14641@yahoo.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Patch to allow specification of interface name prefix
Message-ID: <20070228183535.GB5353@tuxdriver.com>
References: <510326.55988.qm@web50211.mail.yahoo.com> <20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net> <45E112F7.9090908@lwfinger.net> <20070226150241.1b5b63b2@freekitty> <20070227111644.784600be@logostar.upir.cz> <43e72e890702271055sc1525ecy54870626125a7fae@mail.gmail.com> <20070228012500.GB4072@tuxdriver.com> <20070228164437.GA31074@devicescape.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070228164437.GA31074@devicescape.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 28, 2007 at 08:44:37AM -0800, Jouni Malinen wrote:
> On Tue, Feb 27, 2007 at 08:25:00PM -0500, John W. Linville wrote:
> 
> > Hopefully wmaster will fall off the user's radar soon.  Regarding the
> > current wlanX interfaces, most modes will be using ethernet framing,
> > so maybe ethX is fine.
> 
> Why would we need to change anything now? What's wrong with wlan#?

See the earlier parts of the thread... :-)

-- 
John W. Linville
linville@tuxdriver.com
