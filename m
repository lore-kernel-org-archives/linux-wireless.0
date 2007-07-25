Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout08-04.prod.mesa1.secureserver.net ([64.202.165.12]:50812
	"HELO smtpout08.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1758372AbXGYAaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2007 20:30:17 -0400
Message-ID: <46A69998.7020108@seclark.us>
Date: Tue, 24 Jul 2007 20:30:16 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: James Ketrenos <jketreno@linux.intel.com>,
	Axj <axjslack@bluebottle.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] Request for help...
References: <1185289332.46a61474a444c@mail.bluebottle.com>	<20070724161226.GA24344@tuxdriver.com>	<46A64503.1080003@seclark.us>	<20070724203035.GG24344@tuxdriver.com>	<46A66B63.6030006@garzik.org> <46A6A447.2080903@linux.intel.com> <46A69359.4030201@garzik.org>
In-Reply-To: <46A69359.4030201@garzik.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff Garzik wrote:

>James Ketrenos wrote:
>  
>
>>Jeff Garzik wrote:
>>
>>    
>>
>>>There is a reason why we say "release early, release often."  If 
>>>wireless developers don't hear from Intel on a regular basis,
>>>      
>>>
>>The "community" vs. "Intel" slant is really getting old. 
>>*WE* are part of the community.  *WE* have submitted patches.  *WE* have 
>>done work to bring wireless forward.  *WE* are wireless developers.
>>
>>It isn't Intel's fault that certain people have historically made it so 
>>difficult to get code to into wireless-dev's mac80211 (and eventually 
>>*maybe* upstream) that contributors have decided to focus on getting 
>>their code out to users through other means.
>>
>>A version of mac80211 being available out-of-tree with features not 
>>found in wireless-dev isn't the problem.  The problem is that people 
>>have made it too difficult to innovate and develop in wireless-dev.
>>    
>>
>
>Well, the facts according to my search are:
>
>* last iwlwifi submit was almost two months ago, in a form difficult to 
>review and discuss on the mailing list, save for a bug fix.  And I note, 
>the submission went into wireless-dev rapidly.
>
>* last mac80211 patches were almost three months ago, save for two small 
>add-ioctl patches from Mohamed and Hong.
>
>* no one else seems to have the same trouble getting patches in
>
>Whereas other developers are actively posting patches, big and small, to 
>linux-wireless on a regular basis.  I just don't see much activity at 
>all on {linux-kernel,linux-wireless,netdev} from Intel with regards to 
>the new wireless.
>
>Intel is the only wireless driver developer doing development 
>"elsewhere", rather than where the wireless hackers hang out.  Even 
>assuming a hypothetical worst case of 100% patch drops, you should be 
>working and posting where other developers are also working and posting. 
>  That is just a BASIC part of the open source kernel engineering process.
>
>Another key part of open source is "release early, release often" so 
>that people are aware of your work and needs, and can provide rapid 
>feedback.  That means posting most patches to linux-wireless as soon as 
>they work on your basic quick-test setup.  Intel is definitely not 
>"releasing early and often" from the LKML perspective.
>
>Though in fairness, I am a bit disappointed that wireless-dev seems to 
>occasionally become a resting place for drivers, rather than just a pit 
>stop on the way to upstream.  In particular, stuff still has not been 
>moved out of drivers/net/wireless/mac80211 and into 
>drivers/net/wireless, which is a basic and easy step to get all code 
>ready for upstream.
>
>	Jeff
>
>
>  
>
I find it really sad that a hardware vendor that is willing to write and develope drivers for Linux for their hardware aren't helped more by "the community" or is the "the community" only interested in hacking drivers where the manufacturer give no or minimal support?

I appreciate Intel's support for being open and purposely bought a laptop that had an Intel graphics chipset and an Intel wireless card.

My $.02
Steve
"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



