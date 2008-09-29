Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56829 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbYI2VVb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 17:21:31 -0400
Date: Mon, 29 Sep 2008 17:20:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Anna Neal <anna@cozybit.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: Improvements on automatic tx power control
	via SIOCSIWTXPOW.
Message-ID: <20080929212045.GH3295@tuxdriver.com> (sfid-20080929_232135_640603_E63CED89)
References: <48dc2080.14be600a.433d.fffffde3@mx.google.com> <20080926162643.GB3483@tuxdriver.com> <1222721977.27930.45.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1222721977.27930.45.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 29, 2008 at 04:59:37PM -0400, Dan Williams wrote:
> On Fri, 2008-09-26 at 12:26 -0400, John W. Linville wrote:
> > On Thu, Sep 25, 2008 at 04:19:31PM -0700, Anna Neal wrote:
> > > iwconfig txpower can now be used to set tx power to fixed or auto. If set to
> > > auto the default firmware settings are used.
> > > 
> > > The command CMD_802_11_PA_CFG is only sent to older firmware, as Dan Williams
> > > noted the command was no longer supported in firmware V9+.
> > > 
> > > Signed-off-by: Anna Neal <anna@cozybit.com>
> > > Signed-off-by: Javier Cardona <javier@cozybit.com>
> > 
> > I had already committed an earlier version.  I believe I have
> > incorporated all the changes in "libertas: Improvements on automatic tx
> > power control via SIOCSIWTXPOW (fixups)" -- please feel free to verify.
> 
> A few missing bits, sorry for the confusion.  Merge fixups against
> current wireless-testing below.
> 
> Signed-off-by: Dan Williams <dcbw@redhat.com>

Thanks Dan!  I'll fold this into the patch before sending it upstream.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
