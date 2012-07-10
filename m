Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846Ab2GJNhR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 09:37:17 -0400
Date: Tue, 10 Jul 2012 15:37:09 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RHEL6 PATCH] iwlwifi: remove spurious warning
Message-ID: <20120710133708.GC2260@redhat.com> (sfid-20120710_153725_858846_15E4DE5F)
References: <1341834509-11601-1-git-send-email-sgruszka@redhat.com>
 <1341834647.4455.32.camel@jlt3.sipsolutions.net>
 <20120709115423.GE2438@redhat.com>
 <CANUX_P23xv5rXynEJHm=boR_g_7YqR1ROOQki6KGv+9LR9KEkg@mail.gmail.com>
 <20120710060211.GA2260@redhat.com>
 <CANUX_P3Vh1pqyK7TnNdYPS6nHpiUEzWDr4j8+8a5kXdhY3DrAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P3Vh1pqyK7TnNdYPS6nHpiUEzWDr4j8+8a5kXdhY3DrAA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 10, 2012 at 04:15:09PM +0300, Emmanuel Grumbach wrote:
> Emmanuel Grumbach
> egrumbach@gmail.com
> 
> 
> On Tue, Jul 10, 2012 at 9:02 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > On Mon, Jul 09, 2012 at 10:10:38PM +0300, Emmanuel Grumbach wrote:
> >> I would be glad to know on what commands this WARN_ON triggers
> >> though... The command name should be printed along with the WARN_ON.
> >
> > REPLY_RX_PHY_CMD
> >
> 
> Ok thanks. This comes from the fw for every HT frame received in 4965.
> Do you see that the WARNING triggers for every HT frame Rx?
> I don't mind removing that code anyway, I was just asking to
> understand what happens :-)

I did not hit that. It was raported for iwl1000 on RHEL6.3:
https://bugzilla.redhat.com/show_bug.cgi?id=837754

Stanislaw
