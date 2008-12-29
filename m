Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:63541 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbYL2RwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 12:52:20 -0500
Received: by bwz14 with SMTP id 14so16446738bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2008 09:52:18 -0800 (PST)
Message-ID: <69e28c910812290944j10d4477fsab61acdfc79d8c15@mail.gmail.com> (sfid-20081229_185225_177475_B59B1AEB)
Date: Mon, 29 Dec 2008 18:44:58 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Delphi Real Estate" <Info@delphi-real-estate.com>
Subject: Re: Setting 'n' or 'a' Mode, and WPA2?
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <200812290531.47379.Info@delphi-real-estate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200812270706.56478.Info@delphi-real-estate.com>
	 <1230556794.3116.36.camel@johannes>
	 <200812290531.47379.Info@delphi-real-estate.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 29, 2008 at 2:31 PM, Delphi Real Estate
<Info@delphi-real-estate.com> wrote:
>
> On Monday 29 December 2008 5:19:54 Johannes Berg wrote:
>> Umm, no. A single card can only be on one band at a time.
>
> OK, so you're saying that only the 'n' Draft2 routers can do that?  That this firmware for the 4965AGN does not have Draft2 features?
>
> Does it have Draft1 features?
>
> How do you set only 5GHz 'n' mode?  WPA2?

No. An access point can operate on both bands at the same time, but
not a wireless client - a client must choose _one_ band from the
several ones offered by the AP and operate on that band.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
