Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:41622 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756003AbXD0PgM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 11:36:12 -0400
Date: Fri, 27 Apr 2007 17:36:33 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Andy Green <andy@warmcat.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Michael Wu <flamingice@sourmilk.net>,
	James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
Message-ID: <20070427173633.506820ae@griffin.suse.cz>
In-Reply-To: <463216FA.6000206@warmcat.com>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	<200704251634.16604.flamingice@sourmilk.net>
	<46312067.9090005@linux.intel.com>
	<200704262023.52833.flamingice@sourmilk.net>
	<1177684132.21025.36.camel@localhost.localdomain>
	<20070427164208.25434f11@griffin.suse.cz>
	<1177685793.21025.52.camel@localhost.localdomain>
	<20070427172004.32b7bf4a@griffin.suse.cz>
	<463216FA.6000206@warmcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Apr 2007 16:30:02 +0100, Andy Green wrote:
> > fixes the problem. Now, let's find something that fixes the problem as
> > well but doesn't remove the functionality. James already proposed a
> > solution that could work if a support for user space MLME is added. Do
> > you have an idea how to add it?
> 
> Jiri, what functionality?  The ability to change frequency periodically?
>   Isn't that something mac80211 can do already?

Please see other mails in this thread. The opinions differ.

As long as it is implemented cleanly I have no objections against it.

Btw, the main argument for hw_scan was power consumption. I'd still
like to see numbers :-)

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
