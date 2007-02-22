Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3617 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbXBVTVn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Feb 2007 14:21:43 -0500
Date: Thu, 22 Feb 2007 13:45:42 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] d80211: Split antenna selection into TX and RX antenna
Message-ID: <20070222184542.GG5631@tuxdriver.com>
References: <200702211702.46661.IvDoorn@gmail.com> <1172170005.5114.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1172170005.5114.19.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 22, 2007 at 01:46:45PM -0500, Dan Williams wrote:
> On Wed, 2007-02-21 at 17:02 +0100, Ivo van Doorn wrote:

> > This patch will remove the usage of the IOCTL call:
> > PRISM2_PARAM_ANTENNA_SEL but will restore the usage of
> > (the already excisting) IOCTL calls PRISM2_PARAM_ANTSEL_TX and
> > PRISM2_PARAM_ANTSEL_RX.
> 
> We should make sure that antenna selection is something that cfg80211
> can do easily as well, so that we can deprecate the PRISM2_IOCTL calls.

+1

-- 
John W. Linville
linville@tuxdriver.com
