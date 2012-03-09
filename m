Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46107 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661Ab2CIHjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 02:39:45 -0500
MIME-Version: 1.0
In-Reply-To: <4F59800B.80407@lwfinger.net>
References: <CAHaq0gKf+VE9T15J91rvyxbF8=rNCExTZfE-WcwHjUN1afjnTA@mail.gmail.com>
	<CAHaq0gLOPpDKazM0WPmkkOmJ1gR-vqOX9Q+J3nXArD5N0MgmMw@mail.gmail.com>
	<4F581AF8.4080001@lwfinger.net>
	<CAHaq0gKxw9Lir2bB__jNmmZPzbgq7Ky6v9Ps2RVexbnRjd8a2g@mail.gmail.com>
	<4F585BA9.6020903@amd.com>
	<2A76B9D36150BE4293842BC2FE8FF165016A31@SCYBEXDAG04.amd.com>
	<CAHaq0g+hXKdCaMm8dXiQhzqCsjAa0vihd2YE3gbw-xrMrxmOgw@mail.gmail.com>
	<CAHaq0gJRr5p2d=P_J9+NQ0=PqaCu6NLSwJ_LSjFn7HffkX-Odg@mail.gmail.com>
	<4F58F2D0.5060805@lwfinger.net>
	<CAHaq0gKSSgYX19BH92Pg+gXifSEmjvubc_nd5brO8QeLCpr1yA@mail.gmail.com>
	<4F59800B.80407@lwfinger.net>
Date: Fri, 9 Mar 2012 15:39:43 +0800
Message-ID: <CAHaq0gK17axV0uo-EEj4s7=dgOs3vccJ4-icX9YFyBcYGn4u8g@mail.gmail.com> (sfid-20120309_083951_916117_2094C4BA)
Subject: Re: rt8192cu on USB3
From: jerome huang <jerome.syno@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Xu, Andiry" <Andiry.Xu@amd.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
>
> The only changes are in the rtlwifi drivers. I don't have a USB 3 device,
> thus I have no idea what might work there. I wrote something incorrect
> earlier. The new code is not in mainline 3.3, but it is in the
> wireless-testing git tree. If you want to try this, and don't want to get
> the whole tree, the new code is in the bleeding-edge compat-wireless
> package. Otherwise, I could send you the patches.
>
> Larry
>
>

Are other patches recommend besides b0302a?

Jerome
