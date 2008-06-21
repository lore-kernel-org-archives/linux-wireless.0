Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:50450
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939AbYFUBDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 21:03:33 -0400
Subject: Re: [RFC PATCHES] Re: Is configfs the right solution for
	configuration based fs?
From: Ben Nizette <bn@niasdigital.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>,
	Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Felix Fietkau <nbd@openwrt.org>,
	Al Viro <viro@ftp.linux.org.uk>,
	"H. Peter Anvin" <hpa@kernel.org>
In-Reply-To: <20080620213708.GC21416@mail.oracle.com>
References: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com>
	 <1213002187.698.62.camel@johannes.berg>
	 <1213056772.4089.42.camel@moss.renham>
	 <20080619024804.GA29765@mail.oracle.com>
	 <1213942750.2336.43.camel@moss.renham>
	 <20080620065253.GA14238@ca-server1.us.oracle.com>
	 <1213953776.2336.75.camel@moss.renham>
	 <20080620213708.GC21416@mail.oracle.com>
Content-Type: text/plain
Date: Sat, 21 Jun 2008 11:03:49 +1000
Message-Id: <1214010229.2336.88.camel@moss.renham> (sfid-20080621_030422_547963_2325110C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 2008-06-20 at 14:37 -0700, Joel Becker wrote:
> On Fri, Jun 20, 2008 at 07:22:56PM +1000, Ben Nizette wrote:
> > A version of my gpio-dev interface is attached.  Bear in mind it was
> > never completed, it's full of known bugs but hey, might be useful for
> > you anyway :-)
> 
> 	Looks good.  Fits about what I would expect a configfs interface
> to look like, with simple show/store stuff.  I can see where some macros
> would have shortened some bolierplate.
> 	Was there any other boilerplate you found cumbersome?  I mean
> outside of defining attribute structs and the show/store_attr()
> trampoline functions?  Let me know, so I can incorporate it.
> 

You know, I think you've about covered the boilerplate work.  Apart from
that, well it took me a millisecond to work out what the point of
config_{group,item}s was; I went in kinda expecting to see one struct
for directories and one for attributes.  In fact I still not sure I can
explain the need for config_items separate from config_groups.  Little
help?  :-)

	--Ben.

> Joel
> 
