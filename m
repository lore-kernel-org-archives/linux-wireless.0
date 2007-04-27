Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47164 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755959AbXD0Trd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 15:47:33 -0400
Date: Fri, 27 Apr 2007 21:47:54 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Dan Williams <dcbw@redhat.com>
Cc: James Ketrenos <jketreno@linux.intel.com>,
	Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
Message-ID: <20070427214754.532ccfda@griffin.suse.cz>
In-Reply-To: <1177702975.4438.0.camel@localhost.localdomain>
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
	<1177702975.4438.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Apr 2007 15:42:55 -0400, Dan Williams wrote:
> I don't see how they could possibly conflict methodically.  They are two
> paths to the same result.  Or do you mean currently conflict technically
> in the code?

The latter.

 Jiri

-- 
Jiri Benc
SUSE Labs
