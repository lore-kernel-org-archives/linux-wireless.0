Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:48275 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1H0N6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 09:58:48 -0400
Received: by yie30 with SMTP id 30so2359939yie.19
        for <linux-wireless@vger.kernel.org>; Sat, 27 Aug 2011 06:58:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110827151847.02ca7c78@milhouse>
References: <20110707002034.GA17885@broadcom.com>
	<20110824222801.GA5280@broadcom.com>
	<CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
	<20110826175510.GG4888@broadcom.com>
	<CACna6rw8AYxH4e_9NOFux2DPgCvqM+Yg+fit1Q6x==MjFowgwA@mail.gmail.com>
	<20110827151847.02ca7c78@milhouse>
Date: Sat, 27 Aug 2011 15:58:46 +0200
Message-ID: <CACna6rx7POsUPONJqHhTV94icWmL5MPt7q+kMGnJJYartwMOow@mail.gmail.com> (sfid-20110827_155852_173628_1C26B366)
Subject: Re: [PATCH v2] Move brcm80211 to mainline
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
	Henry Ptasinski <henryp@broadcom.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 27 sierpnia 2011 15:18 użytkownik Michael Büsch <m@bues.ch> napisał:
> On Sat, 27 Aug 2011 14:05:19 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>> You can see attached files for raw results or view chart at my blog:
>> http://zajec.net/blog/view/2011-b43-dma-fixed-on-some-pci-cards
>>
>> As you can see, b43 is very comparable with wl/brcmsmac and sometimes
>> can achieve even higher speeds (for high rates in this case).
>>
>> I believe this will make you calmer about quality of the b43.
>
> Impressive.
>
> I think the slightly higher speeds come from the different rate control
> algorithms. However, other than that, I do understand if broadcom
> has certain concerns with supporting the b43 driver _officially_.
> I assume broadcom maintains a QA process internally and b43 simply
> isn't tested by that. And testing costs money. It probably is as simple as that.
>
> It may be hard to tell a sales person that QA has to throw money
> out of the window to test a "redundant" driver.

I see. The situation is everyone prefer his own driver. However b43
has better quality (less hacks), better design (ssb&bcma), more
features (AP, mesh, monitor), more hardware support (all the old cards
and ssb). I can not imagine dropping b43 and it doesn't sound like a
good idea to have 2 drivers for the same hardware.


> So, at the end of the day, I do understand the concerns. However, I would
> also like to see broadcom's QA move towards b43 and start some testing
> on it. Nobody wants the QA to officially support the whole driver tomorrow
> afternoon, already. I'd rather see this as a step by step process. Probably
> leaving legacy G-PHY devices completely out. So QA would say we support
> this and that device on b43, but _not_ those and these..

Henry, can you elaborate on that? How could we help Broadcom to
officially support b43? I'm willing to help & co-operate.


> Also, don't be too hard on Henry. He's nice and very cooperative to
> the linux community within the constraints of the company. :)

I'm sorry, it's just about all the experience with Broadcom we all
have. No cooperating with community, hiding the driver (we found wl.o
in WRT54G firmware), refusing to compile it for x86 for years, and so
on...

Henry: I really would be glad you have community & Broadcom
cooperating. I just don't see a single step from Broadcom into that
direction :| You don't seem to want helping b43, you don't respond to
releasing firmware requests, you can't share hardware other than
what's already available on ebay (sometimes not even that).

Do you see a possibility of cooperating with us? I'm really willing to
help, I'm spending a lot of my free time on b43, I offer my help with
brcmfmac. It just doesn't work if the second side doesn't do a step.

-- 
Rafał
