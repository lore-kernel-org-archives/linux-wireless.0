Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38173 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762404AbXEUQ1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2007 12:27:50 -0400
Date: Mon, 21 May 2007 17:26:59 +0100
From: Christoph Hellwig <hch@infradead.org>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Jeff Garzik <jeff@garzik.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
Message-ID: <20070521162659.GA28901@infradead.org>
References: <464B7B7C.5080800@linux.intel.com> <20070516203505.556df4f9.randy.dunlap@oracle.com> <464E0DB5.5010802@linux.intel.com> <464E233A.6060209@garzik.org> <464E1B4A.8050105@linux.intel.com> <20070518230445.GA29062@infradead.org> <4651B30A.4040908@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4651B30A.4040908@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 21, 2007 at 07:56:10AM -0700, James Ketrenos wrote:
> Christoph Hellwig wrote:
> >On Fri, May 18, 2007 at 02:31:54PM -0700, James Ketrenos wrote:
> >>Alright; I'll add replacing the bitfields with bitwise access to the todo 
> >>list.
> >>
> >>Are you OK with us marking the driver as not working on big endian for 
> >>now and getting this one fixed over time?
> >
> >Given that Intel still hasn't fixed the older ipw2X00 drivers for big
> >endian despite clong-time onstant prodding I'm dead set against this.
> 
> Really?  Long time constant prodding?
> 
> I'll admit I'm not CC:'d on every email regarding the ipw2100 and ipw2200, 
> so if I missed a long-time and constant thread, please forward it my way.  
> Searching Google for 'ipw endian' (and several other searches) found a 
> reference to a fix for an endian issue when it was raised for the ipw2200.  

Just from my outbox I have a thread in August 2006 where I tell Zhu Yi
to fix the endianess problems instead of masking them, and even offer
testing on big endian when Intel sends me hardware.  Despite that this
got completely ignored and resubmitted in december, where I replied again.
And probably quite a few more I haven't caught.

