Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2937 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbXB0CGC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Feb 2007 21:06:02 -0500
Date: Mon, 26 Feb 2007 20:33:20 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Alex Davis <alex14641@yahoo.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: Patch to allow specification of interface name prefix
Message-ID: <20070227013320.GA4476@tuxdriver.com>
References: <510326.55988.qm@web50211.mail.yahoo.com> <20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net> <45E112F7.9090908@lwfinger.net> <20070226150241.1b5b63b2@freekitty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070226150241.1b5b63b2@freekitty>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 26, 2007 at 03:02:41PM -0800, Stephen Hemminger wrote:

> This was hashed out on netdev 2+ years ago and decided that both ethernet
> and wireless devices should show up as 'eth%d'. For inclusion d80211 needs to conform
> to existing mainline kernel practice. If this means breaking the expectation of older
> out of tree wireless support (ie madwifi), sorry.

Any chance you could provide a pointer to that discussion in the archives?

John
-- 
John W. Linville
linville@tuxdriver.com
