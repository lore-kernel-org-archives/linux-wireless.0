Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35090 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594AbXK0E6d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 23:58:33 -0500
Date: Mon, 26 Nov 2007 20:57:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Tony Breeds <tony@bakeyournoodle.com>,
	Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-11-20-01-45 Build Fail -
 net/wireless driver
Message-Id: <20071126205720.6acce34c.akpm@linux-foundation.org> (sfid-20071127_045837_270654_0F280836)
In-Reply-To: <200711262352.24722.flamingice@sourmilk.net>
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
	<200711262331.21176.flamingice@sourmilk.net>
	<20071126203716.ebe62999.akpm@linux-foundation.org>
	<200711262352.24722.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 26 Nov 2007 23:52:09 -0500 Michael Wu <flamingice@sourmilk.net> wrote:

> On Monday 26 November 2007 23:37:16 Andrew Morton wrote:
> > Why not?
> >
> > Having very long and specific identifiers duplicated in two drivers is a
> > daft situation.  Unless they both drive the same hardware, which afaict
> > they do not?
> The radios and macs are very similar (radios could actually be the same, not 
> sure), with modifications to run on whatever bus they're on. That's why I'm 
> going to be merging the rtl8180_rtl8225.c and rtl8187_rtl8225.c into a single 
> piece of code. Besides that, rtl8187 != rtl8225 since rtl8187 is a mac and 
> rtl8225 is a radio. Replacing rtl8225z2 with rtl8187 makes no sense but is 
> okay temporarily to fix build issues in -mm.
> 

Well I assumed that someone would be able to think up a better name than
"rtl8187".  I was thinking of using "foo" to make that clear...

But whatever.  I suppose we should mention allyesconfig in the
file-which-nobody-reads.

