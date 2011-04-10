Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56433 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab1DJPyA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 11:54:00 -0400
Subject: Re: [PATCH 16/16] iwlagn: downgrade warning on unknown TLV
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1302423346.3519.4.camel@jlt3.sipsolutions.net>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1302276636-12802-17-git-send-email-wey-yi.w.guy@intel.com>
	 <1302423346.3519.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Apr 2011 08:34:08 -0700
Message-ID: <1302449648.14995.132.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-10 at 01:15 -0700, Johannes Berg wrote:
> On Fri, 2011-04-08 at 08:30 -0700, Wey-Yi Guy wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > If we maintain API properly, then there isn't
> > really a reason to warn about this since we'll
> > just be adding things that are safe to ignore,
> > so downgrade the warning to debug info level.
> 
> This might be worthwhile for .39 since we'll be releasing firmware with
> some TLVs it doesn't understand eventually.
> 
> johannes
> 
I am not sure it is that important since .39 will not support support
the new TLV and this give a good indication to upgrade even driver
should still works. 
Just like if there are newer version of firmware available for download,
driver do give a warning for it.

Wey



