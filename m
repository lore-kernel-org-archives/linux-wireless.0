Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:58798 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932893AbXB0KQv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 05:16:51 -0500
Date: Tue, 27 Feb 2007 11:16:44 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Alex Davis <alex14641@yahoo.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: Patch to allow specification of interface name prefix
Message-ID: <20070227111644.784600be@logostar.upir.cz>
In-Reply-To: <20070226150241.1b5b63b2@freekitty>
References: <510326.55988.qm@web50211.mail.yahoo.com>
	<20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net>
	<45E112F7.9090908@lwfinger.net>
	<20070226150241.1b5b63b2@freekitty>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[removed bcm43xx-dev list]

On Mon, 26 Feb 2007 15:02:41 -0800, Stephen Hemminger wrote:
> This was hashed out on netdev 2+ years ago and decided that both ethernet
> and wireless devices should show up as 'eth%d'. For inclusion d80211 needs to conform
> to existing mainline kernel practice. If this means breaking the expectation of older
> out of tree wireless support (ie madwifi), sorry.

Decided? I remember just you and hch saying "all existing wireless drivers
do that, so everybody should". When pointing out that just two drivers do
that (I think ipw and prism) and everybody else use something different
(wlan%d most often) there was no reply. "ipw and one other driver do that
so everybody should" doesn't sound like a strong argument to me.

Wireless devices need different handling (setting SSID, etc.) than Ethernet
ones. I think it's not so bad idea to show that difference by using a
different default name. Everybody else who is in some kind different from
Ethernet use different name than eth%d. I think we should conform to
existing mainline practice by using something different than eth%d too.

 Jiri

-- 
Jiri Benc
SUSE Labs
