Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbbLNB5P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2015 20:57:15 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Bob Marcan <bob.marcan@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rtl8xxxu driver status
References: <20151213034035.6c6e0141@smicro.local.lan>
Date: Sun, 13 Dec 2015 20:57:14 -0500
In-Reply-To: <20151213034035.6c6e0141@smicro.local.lan> (Bob Marcan's message
	of "Sun, 13 Dec 2015 03:40:35 +0100")
Message-ID: <wrfjvb81hjwl.fsf@redhat.com> (sfid-20151214_025758_276894_61210571)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Marcan <bob.marcan@gmail.com> writes:
> Hi All.
> Probably in the interest of all  of us, question to
> Jes Sorensen, Jakub Sitnicki and of course Larry Finger.
> In which kernel version the  rtl8xxxu driver  will be included?
> The rtl8192eu chipset are mentioned in some paches.
> Are or will be this chipset supported in this driver?
>
> BR & TIA, Bob

The driver should show up in 4.4, however that version will not have
8192eu support.

I have a couple of 8192eu devices, but I haven't gotten to them yet. I
am currently working on 8723bu support and hopefully it should be fairly
easy to add 8192eu support from there. The 8192eu is a generation
somewhere between the 8723au/8192cu and the 8723bu architecture.

cheers,
Jes
