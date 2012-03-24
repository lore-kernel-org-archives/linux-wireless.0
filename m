Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52433 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab2CXE7D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Mar 2012 00:59:03 -0400
Message-ID: <4F6D5494.3000001@lwfinger.net> (sfid-20120324_055917_088442_73AB9F14)
Date: Fri, 23 Mar 2012 23:59:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Richard Farina <sidhayn@gmail.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	jerome huang <jerome.syno@gmail.com>,
	"Xu, Andiry" <Andiry.Xu@amd.com>, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: rt8192cu on USB3
References: <CAHaq0gKxw9Lir2bB__jNmmZPzbgq7Ky6v9Ps2RVexbnRjd8a2g@mail.gmail.com> <4F585BA9.6020903@amd.com> <2A76B9D36150BE4293842BC2FE8FF165016A31@SCYBEXDAG04.amd.com> <CAHaq0g+hXKdCaMm8dXiQhzqCsjAa0vihd2YE3gbw-xrMrxmOgw@mail.gmail.com> <CAHaq0gJRr5p2d=P_J9+NQ0=PqaCu6NLSwJ_LSjFn7HffkX-Odg@mail.gmail.com> <4F58F2D0.5060805@lwfinger.net> <CAHaq0gKSSgYX19BH92Pg+gXifSEmjvubc_nd5brO8QeLCpr1yA@mail.gmail.com> <4F59800B.80407@lwfinger.net> <20120322223107.GA8877@xanatos> <4F6BDEDF.2020907@lwfinger.net> <20120323203404.GD5207@xanatos> <4F6D2E76.90204@gmail.com>
In-Reply-To: <4F6D2E76.90204@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/23/2012 09:16 PM, Richard Farina wrote:

> Given that I can replicate this issue using several different drivers,
> should I test using 3.4_rc1 kernel to see if the usb is fixed or using
> compat-wireless based on 3.4_rc1 to see if the drivers are fixed? Or both?

You should test 3.4-rc1 first. According to what Sarah wrote, that should fix 
many of the problems. If rtl8192cu still has the problem then, I have a 
potential fix. At the moment, there is nothing in compat-wireless to help this 
problem.

Larry
