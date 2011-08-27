Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:36237 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab1H0NTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 09:19:02 -0400
Date: Sat, 27 Aug 2011 15:18:47 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110827151847.02ca7c78@milhouse> (sfid-20110827_151906_917215_F56E668B)
In-Reply-To: <CACna6rw8AYxH4e_9NOFux2DPgCvqM+Yg+fit1Q6x==MjFowgwA@mail.gmail.com>
References: <20110707002034.GA17885@broadcom.com>
	<20110824222801.GA5280@broadcom.com>
	<CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
	<20110826175510.GG4888@broadcom.com>
	<CACna6rw8AYxH4e_9NOFux2DPgCvqM+Yg+fit1Q6x==MjFowgwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 27 Aug 2011 14:05:19 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:
> You can see attached files for raw results or view chart at my blog:
> http://zajec.net/blog/view/2011-b43-dma-fixed-on-some-pci-cards
> 
> As you can see, b43 is very comparable with wl/brcmsmac and sometimes
> can achieve even higher speeds (for high rates in this case).
> 
> I believe this will make you calmer about quality of the b43.

Impressive.

I think the slightly higher speeds come from the different rate control
algorithms. However, other than that, I do understand if broadcom
has certain concerns with supporting the b43 driver _officially_.
I assume broadcom maintains a QA process internally and b43 simply
isn't tested by that. And testing costs money. It probably is as simple as that.

It may be hard to tell a sales person that QA has to throw money
out of the window to test a "redundant" driver.

So, at the end of the day, I do understand the concerns. However, I would
also like to see broadcom's QA move towards b43 and start some testing
on it. Nobody wants the QA to officially support the whole driver tomorrow
afternoon, already. I'd rather see this as a step by step process. Probably
leaving legacy G-PHY devices completely out. So QA would say we support
this and that device on b43, but _not_ those and these..

Also, don't be too hard on Henry. He's nice and very cooperative to
the linux community within the constraints of the company. :)

-- 
Greetings, Michael.
