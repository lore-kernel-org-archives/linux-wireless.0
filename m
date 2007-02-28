Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4175 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbXB1BfX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 20:35:23 -0500
Date: Tue, 27 Feb 2007 20:25:00 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Larry Finger <larry.finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Alex Davis <alex14641@yahoo.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Patch to allow specification of interface name prefix
Message-ID: <20070228012500.GB4072@tuxdriver.com>
References: <510326.55988.qm@web50211.mail.yahoo.com> <20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net> <45E112F7.9090908@lwfinger.net> <20070226150241.1b5b63b2@freekitty> <20070227111644.784600be@logostar.upir.cz> <43e72e890702271055sc1525ecy54870626125a7fae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890702271055sc1525ecy54870626125a7fae@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 27, 2007 at 01:55:07PM -0500, Luis R. Rodriguez wrote:

> adopt eth%d convention. With SoftMAC (mac80211) things are a bit
> different -- wmaster handles 802.11 frames and wlan%d handles 802.3
> frames. The name does not matter much but it does imply at least that
> I think. As such perhaps mac80211 should change to use eth%d by
> default.

Hopefully wmaster will fall off the user's radar soon.  Regarding the
current wlanX interfaces, most modes will be using ethernet framing,
so maybe ethX is fine.  What about monitor mode?

Doesn't airo use "wifiX" for its monitor interfaces?  For monitor
interfaces, should we adopt that convention as well?

John
-- 
John W. Linville
linville@tuxdriver.com
