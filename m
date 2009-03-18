Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52036 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767AbZCRVpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 17:45:49 -0400
Date: Wed, 18 Mar 2009 17:37:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Arnaud Patard <apatard@mandriva.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH v2] Fix SLAB corruption during rmmod
Message-ID: <20090318213748.GE3527@tuxdriver.com> (sfid-20090318_224612_029533_288BD6B8)
References: <200903161925.41102.IvDoorn@gmail.com> <200903172256.35485.IvDoorn@gmail.com> <20090318130207.GA3527@tuxdriver.com> <200903181432.25098.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200903181432.25098.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 18, 2009 at 02:32:24PM +0100, Ivo van Doorn wrote:
> On Wednesday 18 March 2009, John W. Linville wrote:

> > It's just that the merge conflicts created by this patch were awful.
> > With 2.6.29's release presumably close, maybe this is a candidate
> > for the stable tree?
> 
> That would be fine as well. :)
> Should I resend it to -stable when 2.6.29 final is out?

Honestly, I think that is the best bet.  Please do so!

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
