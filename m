Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.227]:23311 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbYFLRrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 13:47:12 -0400
Received: by wr-out-0506.google.com with SMTP id 69so2170242wri.5
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 10:47:11 -0700 (PDT)
Message-ID: <5ff0631c0806121047m30d15f0cucc21dcc71ded1c8a@mail.gmail.com> (sfid-20080612_194715_904721_EB4BABAB)
Date: Thu, 12 Jun 2008 19:47:11 +0200
From: "Nicolas Deschildre" <ndeschildre@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [OOPS] rt2x00: unplugging an rt73 device oops at usb_kill_urb+0x14/0xd0
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1213290786.2408.2.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <5ff0631c0806120925m1e00482du5175c9b9a2f7f4dd@mail.gmail.com>
	 <1213290786.2408.2.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 12, 2008 at 7:13 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Thu, 2008-06-12 at 18:25 +0200, Nicolas Deschildre wrote:
>> I tried the wireless compatibilty stack from the 5 June.
>> When unplugging a RT73 device from its USB slot, I get the following
>> oops :
> ...
>> [  703.841832] EIP: [<e089fee4>] usb_kill_urb+0x14/0xd0 [usbcore]
>> SS:ESP 0068:ddf61e10
>
> This is fixed in today's wireless-testing.
> compat-wireless-2008-06-12.tar.bz2 appears to contain the fix already.

Thanks for the quick answer!

Nicolas

>
> --
> Regards,
> Pavel Roskin
>
