Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:53249 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbYFTWY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 18:24:56 -0400
Date: Fri, 20 Jun 2008 14:37:08 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>,
	Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Felix Fietkau <nbd@openwrt.org>,
	Al Viro <viro@ftp.linux.org.uk>,
	"H. Peter Anvin" <hpa@kernel.org>
Subject: Re: [RFC PATCHES] Re: Is configfs the right solution for
	configuration based fs?
Message-ID: <20080620213708.GC21416@mail.oracle.com> (sfid-20080621_002500_238477_5F33E1A4)
References: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com> <1213002187.698.62.camel@johannes.berg> <1213056772.4089.42.camel@moss.renham> <20080619024804.GA29765@mail.oracle.com> <1213942750.2336.43.camel@moss.renham> <20080620065253.GA14238@ca-server1.us.oracle.com> <1213953776.2336.75.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213953776.2336.75.camel@moss.renham>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 20, 2008 at 07:22:56PM +1000, Ben Nizette wrote:
> A version of my gpio-dev interface is attached.  Bear in mind it was
> never completed, it's full of known bugs but hey, might be useful for
> you anyway :-)

	Looks good.  Fits about what I would expect a configfs interface
to look like, with simple show/store stuff.  I can see where some macros
would have shortened some bolierplate.
	Was there any other boilerplate you found cumbersome?  I mean
outside of defining attribute structs and the show/store_attr()
trampoline functions?  Let me know, so I can incorporate it.

Joel

-- 

Life's Little Instruction Book #444

	"Never underestimate the power of a kind word or deed."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
