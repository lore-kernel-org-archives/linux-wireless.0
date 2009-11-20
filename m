Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wal-mailgw1.qinetiq-na.com ([65.209.22.159]:13465 "EHLO
	WALQNAOMAIL1T.qnao.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753887AbZKTQN3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 11:13:29 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Subject: RE: Kernel oops in ath9k
Date: Fri, 20 Nov 2009 11:13:30 -0500
Message-ID: <712C9C7AD151C847B09F32EDA56A94CF0115C7F3@WALQNAOMAIL1T.qnao.net>
In-Reply-To: <43e72e890911200654g6bd78909s5b6062cd82155b6d@mail.gmail.com>
References: <712C9C7AD151C847B09F32EDA56A94CF0115C555@WALQNAOMAIL1T.qnao.net> <1258687496.12864.35.camel@ct> <712C9C7AD151C847B09F32EDA56A94CF0115C73C@WALQNAOMAIL1T.qnao.net> <43e72e890911200654g6bd78909s5b6062cd82155b6d@mail.gmail.com>
From: "Douglass, Woodrow" <Woodrow.Douglass@QinetiQ-NA.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Pavel Roskin" <proski@gnu.org>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok I compiled compat-wireless-2.6.32-rc7.tar.bz2, ran the script, and now the kernel outright crashed rather then just oopsing. The terminal is all locked up, is there any way I can post the crash dump here? I'm sorry, but I'm kind of new at this.

Thanks again,
-Woody
 

> -----Original Message-----
> From: Luis R. Rodriguez [mailto:mcgrof@gmail.com] 
> Sent: Friday, November 20, 2009 9:54 AM
> To: Douglass, Woodrow
> Cc: Pavel Roskin; linux-wireless@vger.kernel.org
> Subject: Re: Kernel oops in ath9k
> 
> On Fri, Nov 20, 2009 at 5:56 AM, Douglass, Woodrow 
> <Woodrow.Douglass@qinetiq-na.com> wrote:
> > Thanks for the quick reply Pavel! I've seen this Oops with kernel 
> > 2.6.31.6, as well as with the  latest linux-wireless that I 
> downloaded 
> > on the 18th of november. Also, it's interesting that the card is 
> > identified as having a AR9280 chipset, the website for the card
> > (http://www.ubnt.com/products/sr7112.php) says the card has 
> an AR9220 
> > chipset. Could this be causing the problem?
> 
> Nah, your card is just PCI version of the AR9280. We just 
> need to distinguish that on the print on ath9k load. So 
> PCI-express is AR9280 and mini-pci AR9220.
> 
> > I'm going to repost this to the ath9k mailing list you mentioned.
> 
> linux-wireless is fine too though no need to repost there. I 
> just tested your script with AR5416 and it worked fine, can 
> you please try the latest compat-wireless, either latest 
> stable or bleeding edge?
> 
> http://wireless.kernel.org/en/users/Download/stable
> http://wireless.kernel.org/en/users/Download
> 
>   Luis
> 
