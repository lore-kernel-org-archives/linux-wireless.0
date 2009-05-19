Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:62940 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbZESMMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 08:12:51 -0400
MIME-Version: 1.0
In-Reply-To: <a4423d670905121315g503f4f0ep6a60e9051a2aeb9d@mail.gmail.com>
References: <1242127393-4298-1-git-send-email-a.beregalov@gmail.com>
	 <20090512164448.GJ16247@kroah.com>
	 <a4423d670905121037i3ea96b01s68367c082802684d@mail.gmail.com>
	 <20090512190254.GB1957@kroah.com>
	 <a4423d670905121315g503f4f0ep6a60e9051a2aeb9d@mail.gmail.com>
Date: Tue, 19 May 2009 16:12:50 +0400
Message-ID: <a4423d670905190512x296f6b1cgaa7815fb4f17cac7@mail.gmail.com>
Subject: Re: [PATCH] Staging: agnx: switch config_interface to
	bss_info_changed
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Greg KH <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Cc: gregkh@suse.de, johannes@sipsolutions.net,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/13 Alexander Beregalov <a.beregalov@gmail.com>:
> 2009/5/12 Greg KH <greg@kroah.com>:
>> On Tue, May 12, 2009 at 09:37:56PM +0400, Alexander Beregalov wrote:
>>> 2009/5/12 Greg KH <greg@kroah.com>:
>>> > On Tue, May 12, 2009 at 03:23:13PM +0400, Alexander Beregalov wrote:
>>> >> Fix this build error:
>>> >> drivers/staging/agnx/pci.c: In function 'agnx_config_interface':
>>> >> drivers/staging/agnx/pci.c:315: error: dereferencing pointer to incomplete type
>>> >> ..
>>> >> drivers/staging/agnx/pci.c:424: error: unknown field 'config_interface' specified in initializer
>>> >>
>>> >> config_interface was removed in 2d0ddec5b2b
>>> >> ("mac80211: unify config_interface and bss_info_changed")
>>> >
>>> > I do not see that patch in Linus's tree.  Is it in some other tree
>>> > (wireless?) and not yet in mainline?
>>> Yes, it is in wireless from linux-next.
>>> You asked to send patches based on linux-next, right?
>>> Should I always mark patches for staging-next tree as [PATCH -next] ?
>>
>> Hm, yes, -staging patches need to be against -next, but I have to be
>> able to build these somehow on my own without the wireless tree...
>>
>> I think something like this might better go through the wireless tree as
>> it depends on changes that happen there.  Sound good to you?
> Ok, thanks Greg.
>
>> If so, please send them to the wireless maintainer.
> John, will you apply it?

John?
