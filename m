Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbaBRKzg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 05:55:36 -0500
Date: Tue, 18 Feb 2014 11:57:56 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tino Keitel <tino.keitel@tikei.de>
Cc: linux-wireless@vger.kernel.org,
	Pedro Francisco <pedrogfrancisco@gmail.com>
Subject: Re: Power saving features for iwl4965
Message-ID: <20140218105755.GD1741@redhat.com> (sfid-20140218_115539_843285_512C204A)
References: <20120418203543.GA16000@x61.home>
 <20120425122554.GD2466@redhat.com>
 <20120503182853.GA12461@mac.home>
 <20121226185425.GA12627@x61.home>
 <20130107110759.GC6931@redhat.com>
 <20130603085239.GA26920@mac.home>
 <20130603141804.GA2146@redhat.com>
 <20130611185120.GA8751@x61.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130611185120.GA8751@x61.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 11, 2013 at 08:51:20PM +0200, Tino Keitel wrote:
> On Mon, Jun 03, 2013 at 16:18:05 +0200, Stanislaw Gruszka wrote:
> 
> > Could you try this experimental patch?
> 
> Hi,
> 
> on top of kernel 3.9.4 (with TuxOnIce patch), iwconfig wlan0 power on
> now saves more than 1 W on my ThinkPad X61s with iwl4965. I can finally
> switch to a recent kernel. Thanks a lot.

This patch stuck on mailing list far too long, I'll post it. Even if it
crash firmware on 3945, power save is disabled by default.

Stanislaw
