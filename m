Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50819 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175AbaDVUPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 16:15:18 -0400
Date: Tue, 22 Apr 2014 16:07:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2014-04-13
Message-ID: <20140422200732.GE16193@tuxdriver.com> (sfid-20140422_233028_817090_338FFF39)
References: <534AE330.2020805@gmail.com>
 <534AE499.6020009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <534AE499.6020009@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 13, 2014 at 10:25:13PM +0300, Emmanuel Grumbach wrote:
> 
> 
> On 04/13/2014 10:19 PM, Emmanuel Grumbach wrote:
> > Hi John,
> > 
> > This is for 3.16.
> > 
> > I have here a bunch of unrelated things. I disabled support for -7.ucode which means that I can removed a lot of code. Eliad has a brand new feature: we reduce the Tx power when the link allows - this reduces our power consumption. The regular changes in power and scan area. One interesting thing though is the patches from Johannes, we have now GRO which allows to increase our throughput in TCP Rx. The main advantage is that it reduces the number of TCP Acks - these TCP Acks are completely useless when we are using A-MPDU since the first packet of the A-MPDU generates a TCP Ack which is made obsolete by the next packets.
> > 
> > Same footer as previous pull request, I won't be available this week, so let's hope I am not causing any problem here.
> > 
> > Thanks!
> > 
> > The following changes since commit a31267c30880ebdc73e6815f58c69a665052fab8:
> > 
> >   rtl8187: fix use after free on failure path in rtl8187_probe() (2014-03-31 13:47:41 -0400)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git master
> > 
> > for you to fetch changes up to 3cd5279b021de6501a8012dd856d7a78ee58ead9:
> > 
> Apparently I can't get the rid of my tradition to fixup something after the mail goes out...
> 
> I dropped 2 patches that I queued up for 3.15 in my next pull request - new HEAD: e03bbb62cfdf539ae8110b297493c685f9d12774


Pulled today...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
