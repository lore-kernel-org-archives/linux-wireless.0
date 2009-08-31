Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:36815 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbZHaX43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 19:56:29 -0400
Received: by iwn42 with SMTP id 42so2014802iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 16:56:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910908311646w315bef9eo43d3342c13e38fca@mail.gmail.com>
References: <h7eo7q$7ks$1@ger.gmane.org> <3ace41890908311055s5c49a25fjf69ca48024579d44@mail.gmail.com>
	<43e72e890908311102q2ed9e8b3q8f1f15d45a29b2f1@mail.gmail.com>
	<3ace41890908311132g16783b68y2d1771ce1d2780d@mail.gmail.com>
	<43e72e890908311141k6bcf5edbl6bce2b88670fb5f8@mail.gmail.com>
	<3ace41890908311157v4fbc9829j6db9c91ef6fff3c7@mail.gmail.com>
	<4A9C3C59.5010305@lwfinger.net> <69e28c910908311418l7f033b5bp7a9b443cd253304@mail.gmail.com>
	<43e72e890908311637r7b079e9fj2ac6b77f2b59eb79@mail.gmail.com>
	<69e28c910908311646w315bef9eo43d3342c13e38fca@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 31 Aug 2009 16:56:11 -0700
Message-ID: <43e72e890908311656o6f4a4157k6f967dc4934e6dd0@mail.gmail.com>
Subject: Re: rtl8187b Problem with tx level
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Greg KH <greg@kroah.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Tobias Schlemmer <keinstein_junior@gmx.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/31 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Tue, Sep 1, 2009 at 1:37 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
>> 2009/8/31 Gábor Stefanik <netrolller.3d@gmail.com>:
>>> On Mon, Aug 31, 2009 at 11:10 PM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
>>>> Hin-Tak Leung wrote:
>>>>>
>>>>> I just took a look at the history - there aren't obvious bug fixes, a
>>>>> bunch of work queue-related changes from you & Johannes; feature-wise,
>>>>> Larry added LED blinking after 2.6.30, and Herton added rfkill support
>>>>> quite recently after 2.6.31-rc7 . But no, there isn't any change that
>>>>> would affect tx level beyond 2.6.31-rc7, I think.
>>>>
>>>> Your analysis matches my recollection.
>>>>
>>>> Apparently RealTek is supplying a closed-source driver for RTL8187B
>>>> these days. There are no sources for the B on their web site. In
>>>> addition, the one that Tobias loaded tainted his kernel.
>>>>
>>>> Larry
>>>
>>> The driver is not actually closed-source; they just don't provide any
>>> drivers on their site anymore, instead they send their reference
>>> drivers to OEMs, expecting the OEMs to release their own versions
>>> (with sources - most vendors who do release Linux drivers in fact only
>>> release sources, without binaries). The reason for this appears to be
>>> that Realtek now encourages vendors to sell RTL81xx wireless chips
>>> with modified USB IDs. (Or are you seeing a binary-only driver on
>>> realtek.com.tw? That would definitely be a GPL violation, given that
>>> they use a modified version of the GPLed libipw stack.)
>>
>> Gabor, do you speak to RealkTek folks? It seems what may be best for
>> OEMs and RealTek themselves is to post drivers for inclusion into
>> staging first and then for interested parties to port them properly.
>>
>>  Luis
>
> Not yet, I haven't tried contacting them. I simply based my comments
> on the fact that OEMs are releasing sources. However, contacting them
> about work to include their drivers in the kernel is a good idea -
> apparently there is nothing keeping Realtek from taking community
> contributions (unlike e.g. Zydas - the vendor driver is based on
> Andrea Merello's old r8180-sa2400 driver, and was not developed
> in-house by Realtek).

If anyone has contacts that does indeed seem reasonable to do, seems
like it could help them and their customers.

  Luis
