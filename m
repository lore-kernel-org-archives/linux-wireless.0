Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab2GILy3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 07:54:29 -0400
Date: Mon, 9 Jul 2012 13:54:24 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RHEL6 PATCH] iwlwifi: remove spurious warning
Message-ID: <20120709115423.GE2438@redhat.com> (sfid-20120709_135435_432922_AAEDDD56)
References: <1341834509-11601-1-git-send-email-sgruszka@redhat.com>
 <1341834647.4455.32.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1341834647.4455.32.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 09, 2012 at 01:50:47PM +0200, Johannes Berg wrote:
> On Mon, 2012-07-09 at 13:48 +0200, Stanislaw Gruszka wrote:
> > BZ#837754
> > 
> > Description:
> > Some devices do not set SEQ_RX_FRAME flags for few commands that should
> > not be reclaimed. It was supposed to be fixed in firmware, but it was
> > not.
> > 
> > Upstream change also add possibility to configure which commands should
> > not be reclaimed, but that option is not used - only original 6 commands
> > are configured. So I did not backport that part, because it make things
> > somewhat (not necessarily) complex.
> 
> Yeah, looks fine. I'd hoped it was fixed for iwlwifi drivers (we
> couldn't remember if it was 4965 only or not) but it turns out it wasn't
> so this is needed.
> 
> I don't know if there's anything I should do about this though?

Sorry Johannes that was not intended to go to you and to the public.

Stanislaw
