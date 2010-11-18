Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62822 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab0KRUxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 15:53:37 -0500
Received: by gxk23 with SMTP id 23so2188086gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 12:53:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101118204045.GE2468@tuxdriver.com>
References: <20101031134012.F21FF9D401B@zog.reactivated.net>
	<1289604579.21000.5.camel@dcbw.foobar.com>
	<AANLkTinpvmS1ZH=T5BtA3+qyYLnNijxfjonFMaY8fO4F@mail.gmail.com>
	<20101118204045.GE2468@tuxdriver.com>
Date: Thu, 18 Nov 2010 20:53:37 +0000
Message-ID: <AANLkTi=uimE0jt+UeSzrx96cKAF705eNXzj1Xy2qRW28@mail.gmail.com>
Subject: Re: [PATCH] libertas: don't block usb8388 suspend if no wakeup
 conditions are set
From: Daniel Drake <dsd@laptop.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	akarwar@marvell.com, Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 November 2010 20:40, John W. Linville <linville@tuxdriver.com> wrote:
> On Thu, Nov 18, 2010 at 08:15:55PM +0000, Daniel Drake wrote:
>> John, just a quick ping on this maintainer-acked patch
>> Thanks :)
>
> I have it in wireless-next-2.6.  Do you think it needs to be in 2.6.37?

Sorry about that. Must have missed it!
linux-next is good enough.

Thanks
Daniel
