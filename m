Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:37016 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933130AbbCDQjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 11:39:55 -0500
MIME-Version: 1.0
In-Reply-To: <20150304173805.3daea9c5@wiggum>
References: <BLU436-SMTP3656F4A0610686DAE30BA1B9110@phx.gbl>
	<CACna6rxJ_uQHmpQS9NPs9JW=zNS4oc2-_cH6nXG0Z9CWu7iW7A@mail.gmail.com>
	<CACna6ryi4ACAfkYRDGTWkwGh9PQrj9zxcnaWjO56m1dyhmiFGA@mail.gmail.com>
	<CACna6rxtvwQxrsRuRt0XLAyQg5rKFf2VqNm6Vrzic5gMCbJDcg@mail.gmail.com>
	<20150304173805.3daea9c5@wiggum>
Date: Wed, 4 Mar 2015 17:39:54 +0100
Message-ID: <CACna6rwFN7BhXUccGFLs8P9QGnrJHWDgR9BXBvE7V9aM9JvJag@mail.gmail.com> (sfid-20150304_174044_898869_B5BE68F2)
Subject: Re: [PATCH] bcma: Kconfig: Let it depend on PCI
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: Chen Gang <xili_gchen_5257@hotmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 March 2015 at 17:38, Michael Büsch <m@bues.ch> wrote:
> On Wed, 4 Mar 2015 14:36:10 +0100
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> Any other opinions?
>
> I think this is the only way to go.
> In ssb we always had optional pcicore driver, as far as I remember,
> so we should have the same in bcma, too.
> The old WRT54G kernel used to compile just fine with SSB and without any PCI enabled.

Thanks. I'll start working on this in a second.

-- 
Rafał
