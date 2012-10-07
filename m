Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51679 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2JGKQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Oct 2012 06:16:36 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so2345698lbo.19
        for <linux-wireless@vger.kernel.org>; Sun, 07 Oct 2012 03:16:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKoUArkmH+tSj8HCTH_Y6FiFbSHbdWofFrxfs0gQ5o6h2k-YEA@mail.gmail.com>
References: <0C7D424D957547489E16A29D0D15433494C29E7FE8@AMKMS11.ad.turkuamk.fi>
	<CAKoUArnsntysudq3CRric4gb3eUOLq2f9ppkUGxbqWhSZp7yhg@mail.gmail.com>
	<5070944B.4010205@lwfinger.net>
	<20121007113348.42ba05fa@milhouse>
	<CAKoUArkmH+tSj8HCTH_Y6FiFbSHbdWofFrxfs0gQ5o6h2k-YEA@mail.gmail.com>
Date: Sun, 7 Oct 2012 12:16:35 +0200
Message-ID: <CAKoUArnj4WBCVYu4D3AQsLg7Zs6xY8pdeKKw4cyik9vYwimNeg@mail.gmail.com> (sfid-20121007_121640_532413_C52393FC)
Subject: Re: OpenFWWF for b43
From: Rami Rosen <roszenrami@gmail.com>
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?ISO-8859-1?Q?Mikko_V=2E_Viinam=E4ki?=
	<Mikko.Viinamaki@students.turkuamk.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
A little correction to my previous mail:
When trying:
 git clone git://git.bues.ch/git/b43-tools.git
The error was:

fatal: remote error: access denied or repository not exported:
/git/b43-tools.git

Rami Rosen


On Sun, Oct 7, 2012 at 12:13 PM, Rami Rosen <roszenrami@gmail.com> wrote:
> Hi,
>
> Thanks a lot!
>
>> The bu3sch.de domain is no longer registered (by me). All services are available
>> under bues.ch now.
>>
>> git clone git://git.bues.ch/git/b43-tools.git
>>
>
> It seems that the "/git/" inside this URL in wrong.
>
> I tried as suggested:
> And get:
> fatal: destination path 'b43-tools' already exists and is not an empty
> directory.
>
> However:
> git clone git://git.bues.ch/b43-tools.git
> worked fine.
>
> Regards,
> Rami Rosen
>
> http://ramirose.wix.com/ramirosen#!home/mainPage
