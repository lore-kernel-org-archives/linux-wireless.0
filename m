Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3518 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287AbXJJPi5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 11:38:57 -0400
Date: Wed, 10 Oct 2007 11:20:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
Subject: Re: mac80211/iwlwifi + hidden ssids
Message-ID: <20071010152027.GF5962@tuxdriver.com> (sfid-20071010_163901_037577_F3E11A0F)
References: <470C9F28.1070803@gmail.com> <20071010130653.GB5962@tuxdriver.com> <1192026847.9739.4.camel@localhost.localdomain> <f6ca9fed0710100757gbcd364esdd94f114cfe1019@mail.gmail.com> <1192028866.9739.32.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1192028866.9739.32.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 10, 2007 at 11:07:46AM -0400, Dan Williams wrote:
> On Wed, 2007-10-10 at 16:57 +0200, dragoran wrote:

> > btw shouldn't all mac80211 drivers either work or not work because the
> > code for this is in mac80211 and not in the drivers?
> 
> Yeah, pretty much; but each driver/firmware may handle hidden ssids
> slightly differently.  mac80211 should bring some sanity to this area,
> but I wouldn't discount variation between even mac80211 based drivers.

Hmmm...doesn't the iwlwifi firmware intercede in scanning?

John
-- 
John W. Linville
linville@tuxdriver.com
