Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:64270 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756515AbXEUSLx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2007 14:11:53 -0400
Message-ID: <4651CD5E.10801@linux.intel.com>
Date: Mon, 21 May 2007 09:48:30 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jeff Garzik <jeff@garzik.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
References: <464B7B7C.5080800@linux.intel.com> <20070516203505.556df4f9.randy.dunlap@oracle.com> <464E0DB5.5010802@linux.intel.com> <464E233A.6060209@garzik.org> <464E1B4A.8050105@linux.intel.com> <20070518230445.GA29062@infradead.org> <4651B30A.4040908@linux.intel.com> <20070521162659.GA28901@infradead.org>
In-Reply-To: <20070521162659.GA28901@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christoph Hellwig wrote:
> On Mon, May 21, 2007 at 07:56:10AM -0700, James Ketrenos wrote:
>> Christoph Hellwig wrote:
>>> On Fri, May 18, 2007 at 02:31:54PM -0700, James Ketrenos wrote:
>>>> Alright; I'll add replacing the bitfields with bitwise access to the todo 
>>>> list.
>>>>
>>>> Are you OK with us marking the driver as not working on big endian for 
>>>> now and getting this one fixed over time?
>>> Given that Intel still hasn't fixed the older ipw2X00 drivers for big
>>> endian despite clong-time onstant prodding I'm dead set against this.
>> Really?  Long time constant prodding?
>>
>> I'll admit I'm not CC:'d on every email regarding the ipw2100 and ipw2200, 
>> so if I missed a long-time and constant thread, please forward it my way.  
>> Searching Google for 'ipw endian' (and several other searches) found a 
>> reference to a fix for an endian issue when it was raised for the ipw2200.  
> 
> Just from my outbox I have a thread in August 2006 where I tell Zhu Yi
> to fix the endianess problems instead of masking them, and even offer
> testing on big endian when Intel sends me hardware.  Despite that this
> got completely ignored and resubmitted in december, where I replied again.
> And probably quite a few more I haven't caught.

Ok, first, you said 'ipw2x00'  Which is false.  The ipw2200 does work on big endian.  We have worked to enable it.  You also said merging w/out fixing big endian leads to big endian never being fixed.  Again, false (see prior email with specific references demonstrating that). 
So, Please don't generalize and make false accusations.

Second, regarding your prior thread, you more or less demanded that the driver maintainer send you hardware.  That isn't fair or reasonable.

If you have a bug, and users that can help resolve the bug, we'd love to work with them fix the issues.  But demanding that Yi send you hardware and then making stuff up about him and the ipw2100, ipw2200, and iwlwifi projects when he doesn't is really not appropriate.

James 
