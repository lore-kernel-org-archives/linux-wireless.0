Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:53306 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbZHIJef (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 05:34:35 -0400
Date: Sun, 9 Aug 2009 11:34:30 +0200
From: Johannes Stezenbach <js@sig21.net>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: ath5k broken after suspend-to-ram
Message-ID: <20090809093430.GA6325@sig21.net>
References: <20090807215155.GA17043@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090807215155.GA17043@sig21.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 07, 2009 at 11:51:55PM +0200, Johannes Stezenbach wrote:
> 
> On my old Thinkpad T42p running linux-2.6.31-rc5-246-g90bc1a6,
> after suspend-to-RAM ath5k cannot associate to an AP using WPA
> anymore.  It worked with kernel 2.6.29.1.

FWFI, it also works with 2.6.30.  (I could not initialliy test
with 2.6.30 because suspend/resume is broken in that kernel,
but it can be fixed up with a workaround patch.)


Johannes
