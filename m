Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43127 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbYJaTqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 15:46:04 -0400
Date: Fri, 31 Oct 2008 15:35:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Anna Neal <anna@cozybit.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] libertas: iwpriv commands to configure fine grained
	wake-on-(w)lan
Message-ID: <20081031193504.GF4310@tuxdriver.com> (sfid-20081031_204611_205737_1CB8278A)
References: <48fe2917.131e640a.7efb.7d0b@mx.google.com> <1224620028.15561.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1224620028.15561.10.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 04:13:47PM -0400, Dan Williams wrote:
> On Mon, 2008-10-20 at 16:49 -0700, Anna Neal wrote:
> > View README for new API.
> > 
> > This patch implements the userspace interface for fine-grained configuration of
> > wake-on-(w)lan.  We are aware that iwpriv's are discouraged, but this is a
> > vendor-specific feature that's currently being used in the OLPC project.
> > 
> > We are aware that all iwprivs were removed from this driver.  These used the old
> > API for iwprivs.  We've implemented this iwpriv as a private handler which relies
> > on wireless extensions to do bounds checking and copying to/from user memory.
> > Specific suggestions on how to make this more palatable for upstream inclusion
> > are welcome.  If iwprivs are completely unacceptable then this can serve as a
> > public reference for interfacing with these features.
> 
> IMHO we should be adding the functionality where's it's needed, which is
> that ethtool, which doesn't have a verbose enough syntax for it's WOL
> support.  If ethtool's existing WOL got fixed up to support these
> use-cases, then we wouldn't need iwpriv commands, we wouldn't have
> duplicate functionality running around, and everyone gets a pony.  Lets
> kick off that discussion...
> 
> Jeff: could something like this syntax be added to ethtool, or maybe
> discreet commands instead of one?  Thoughts?

Did anything come out of this discussion?  I'd prefer not to add new
iwpriv stuff...

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
