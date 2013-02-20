Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f169.google.com ([209.85.161.169]:35893 "EHLO
	mail-gg0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933406Ab3BTHQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 02:16:01 -0500
Message-ID: <5124782D.3050803@lwfinger.net> (sfid-20130220_081610_143309_6C41341A)
Date: Wed, 20 Feb 2013 01:15:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Julian Calaby <julian.calaby@gmail.com>,
	David Miller <davem@davemloft.net>, David.Laight@aculab.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, bittorf@bluebottle.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] b43: Increase number of RX DMA slots
References: <20130219.005206.397289032011003833.davem@davemloft.net> <AE90C24D6B3A694183C094C60CF0A2F6026B7152@saturn3.aculab.com> <5123BCFF.5090408@lwfinger.net> <20130219.131553.787630407148880340.davem@davemloft.net> <5123C43D.2020602@lwfinger.net> <CAGRGNgWZ0qUJSSkjmP8o4VaPRBdN67J=RPy5+45rWaQQXWnWrQ@mail.gmail.com> <512437FA.2030105@lwfinger.net> <CA+XFjipJHGTvzUx6yy1DTc74kbrPEQxM08zW=N1uf43=Q6pwdg@mail.gmail.com>
In-Reply-To: <CA+XFjipJHGTvzUx6yy1DTc74kbrPEQxM08zW=N1uf43=Q6pwdg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2013 12:26 AM, Gábor Stefanik wrote:
>
> Is this an issue that vendor drivers are also vulnerable to? If it is
> a firmware issue, I would certainly think so.

I also think so, at least if they are using the firmware version that Bastian is 
using. His logs don't have that info in them, but I certainly saw the problem on 
my BCM4312 using firmware 508.154 from 2009.

Larry



