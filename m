Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:45138 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756981AbXD0SKf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 14:10:35 -0400
Date: Fri, 27 Apr 2007 20:10:54 +0200
From: Jiri Benc <jbenc@suse.cz>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
Message-ID: <20070427201054.61b9bc4c@griffin.suse.cz>
In-Reply-To: <46322CA9.7090606@linux.intel.com>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	<200704251634.16604.flamingice@sourmilk.net>
	<46312067.9090005@linux.intel.com>
	<200704262023.52833.flamingice@sourmilk.net>
	<1177684132.21025.36.camel@localhost.localdomain>
	<20070427164208.25434f11@griffin.suse.cz>
	<1177685793.21025.52.camel@localhost.localdomain>
	<20070427172004.32b7bf4a@griffin.suse.cz>
	<46322CA9.7090606@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Apr 2007 10:02:33 -0700, James Ketrenos wrote:
> Jiri Benc wrote:
> > The proposed solution (removing of the hw_scan callback) obviously
> > fixes the problem. 
> 
> No, it doesn't fix the problem--it removes the functionality.  Deleting
> automatic AP selection "fixes the problem" too.

Yes. But if these two features conflict with each other and I have to
decide which one should be kept... well.. that's easy.

Of course I'd prefer a correct fix.

Btw, automatic AP selection works quite well for me (at least with
bcm43xx).

 Jiri

-- 
Jiri Benc
SUSE Labs
