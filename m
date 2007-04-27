Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757063AbXD0Tjh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 15:39:37 -0400
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
From: Dan Williams <dcbw@redhat.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: James Ketrenos <jketreno@linux.intel.com>,
	Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070427201054.61b9bc4c@griffin.suse.cz>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	 <200704251634.16604.flamingice@sourmilk.net>
	 <46312067.9090005@linux.intel.com>
	 <200704262023.52833.flamingice@sourmilk.net>
	 <1177684132.21025.36.camel@localhost.localdomain>
	 <20070427164208.25434f11@griffin.suse.cz>
	 <1177685793.21025.52.camel@localhost.localdomain>
	 <20070427172004.32b7bf4a@griffin.suse.cz>
	 <46322CA9.7090606@linux.intel.com>
	 <20070427201054.61b9bc4c@griffin.suse.cz>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 15:42:55 -0400
Message-Id: <1177702975.4438.0.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-04-27 at 20:10 +0200, Jiri Benc wrote:
> On Fri, 27 Apr 2007 10:02:33 -0700, James Ketrenos wrote:
> > Jiri Benc wrote:
> > > The proposed solution (removing of the hw_scan callback) obviously
> > > fixes the problem. 
> > 
> > No, it doesn't fix the problem--it removes the functionality.  Deleting
> > automatic AP selection "fixes the problem" too.
> 
> Yes. But if these two features conflict with each other and I have to
> decide which one should be kept... well.. that's easy.

I don't see how they could possibly conflict methodically.  They are two
paths to the same result.  Or do you mean currently conflict technically
in the code?

dan

> Of course I'd prefer a correct fix.
> 
> Btw, automatic AP selection works quite well for me (at least with
> bcm43xx).
> 
>  Jiri
> 

