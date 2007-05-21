Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:30849 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755442AbXEUQTW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2007 12:19:22 -0400
Message-ID: <4651B30A.4040908@linux.intel.com>
Date: Mon, 21 May 2007 07:56:10 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jeff Garzik <jeff@garzik.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
References: <464B7B7C.5080800@linux.intel.com> <20070516203505.556df4f9.randy.dunlap@oracle.com> <464E0DB5.5010802@linux.intel.com> <464E233A.6060209@garzik.org> <464E1B4A.8050105@linux.intel.com> <20070518230445.GA29062@infradead.org>
In-Reply-To: <20070518230445.GA29062@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christoph Hellwig wrote:
> On Fri, May 18, 2007 at 02:31:54PM -0700, James Ketrenos wrote:
>> Alright; I'll add replacing the bitfields with bitwise access to the todo 
>> list.
>>
>> Are you OK with us marking the driver as not working on big endian for now 
>> and getting this one fixed over time?
> 
> Given that Intel still hasn't fixed the older ipw2X00 drivers for big
> endian despite clong-time onstant prodding I'm dead set against this.

Really?  Long time constant prodding?

I'll admit I'm not CC:'d on every email regarding the ipw2100 and ipw2200, so if I missed a long-time and constant thread, please forward it my way.  

Searching Google for 'ipw endian' (and several other searches) found a reference to a fix for an endian issue when it was raised for the ipw2200.  For the ipw2100 I see a post back in 2004 by one person asking if anyone had tried the ipw2100 on a big endian system.

> It just won't happen if you don't do it now.

Well, if you have evidence to this then great.  If not, please don't spread FUD.

Historical footnote #1 -- the ipw2200 driver was added to the kernel w/out big endian support:
	commit: 43f66a6ce8da299344cf1bc2ac2311889cc88555

Historical footnote #2 -- we fixed big endian problems with the driver in August 2005
	commit: a613bffd3aac89bb0a8c9b7afa72af9b0ae30f0a (and a few other commits as users reported issues)

For the ipw2100, aside from one post in 2004 referencing it, I don't see anything.

James
