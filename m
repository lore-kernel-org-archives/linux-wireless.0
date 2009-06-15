Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:45389 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbZFOUXc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 16:23:32 -0400
Date: Mon, 15 Jun 2009 13:19:34 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	tshibata@ab.jp.nec.com
Subject: Re: [RFC] Documentation: add documentation for rc-series and merge
	window
Message-ID: <20090615201934.GA12685@kroah.com>
References: <1245096771-3966-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1245096771-3966-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 15, 2009 at 04:12:51PM -0400, Luis R. Rodriguez wrote:
> This is losely based on previous discussions on linux-kernel [1][2].
> 
> [1] http://marc.info/?l=linux-kernel&m=122048427801324&w=2
> [2] http://marc.info/?l=linux-netdev&m=122048757705315&w=2
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> 
> I have run into issues when trying to explain this and policies
> for the rc-series, it seems there is no place that documents this
> clearly so here is an attempt based on some previous discussions.
> Not sure if I got it all correct, so feedback is welcomed. I do think
> clarifying this a little should help.
> 
> I was also not sure if Documentation/stable_kernel_rules.txt is the best
> splace for this as well, please let me know.

I don't think this is the best place for it, as the stable_* file is for
describing the rules for the 2.6.x.y releases, not the main 2.6.x
releases.

A new file perhaps?  Or an addition to the
Documentation/development-process/ book?

thanks,

greg k-h
