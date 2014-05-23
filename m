Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47451 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbaEWI62 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 04:58:28 -0400
Message-ID: <1400835498.4358.9.camel@jlt4.sipsolutions.net> (sfid-20140523_105833_307916_05791DD3)
Subject: Re: [PATCH] mac80211: add a single-transaction driver op to switch
 contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 23 May 2014 10:58:18 +0200
In-Reply-To: <CA+BoTQkof_e_T=xegftVHdKK_XFeb2HegOQWmV5+PkCdLkzEyg@mail.gmail.com> (sfid-20140523_100116_761277_D988CC7D)
References: <1400769938.4174.29.camel@jlt4.sipsolutions.net>
	 <1400812703-15685-1-git-send-email-luca@coelho.fi>
	 <CA+BoTQkof_e_T=xegftVHdKK_XFeb2HegOQWmV5+PkCdLkzEyg@mail.gmail.com>
	 (sfid-20140523_100116_761277_D988CC7D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-23 at 10:01 +0200, Michal Kazior wrote:

> So.. which patch are we going forward with? Luca's or mine? Either way
> is fine with me as long as we reach a conclusion :-)

Looks like both are missing some things? Luca's doesn't have tracing,
and supports just a single interface (which you'll not like :) ) but
personally I liked the struct API a bit better than multiple double
pointer arrays you had.

johannes

