Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:63735 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbZHaViP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 17:38:15 -0400
Received: by ewy2 with SMTP id 2so712158ewy.17
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 14:38:16 -0700 (PDT)
Message-ID: <4A9C42C5.6050400@lwfinger.net>
Date: Mon, 31 Aug 2009 16:38:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Hin-Tak Leung <hintak.leung@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Tobias Schlemmer <keinstein_junior@gmx.net>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8187b Problem with tx level
References: <h7eo7q$7ks$1@ger.gmane.org> <3ace41890908311055s5c49a25fjf69ca48024579d44@mail.gmail.com> 	<43e72e890908311102q2ed9e8b3q8f1f15d45a29b2f1@mail.gmail.com> 	<3ace41890908311132g16783b68y2d1771ce1d2780d@mail.gmail.com> 	<43e72e890908311141k6bcf5edbl6bce2b88670fb5f8@mail.gmail.com> 	<3ace41890908311157v4fbc9829j6db9c91ef6fff3c7@mail.gmail.com> 	<4A9C3C59.5010305@lwfinger.net> <69e28c910908311418l7f033b5bp7a9b443cd253304@mail.gmail.com>
In-Reply-To: <69e28c910908311418l7f033b5bp7a9b443cd253304@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> 
> The driver is not actually closed-source; they just don't provide any
> drivers on their site anymore, instead they send their reference
> drivers to OEMs, expecting the OEMs to release their own versions
> (with sources - most vendors who do release Linux drivers in fact only
> release sources, without binaries). The reason for this appears to be
> that Realtek now encourages vendors to sell RTL81xx wireless chips
> with modified USB IDs. (Or are you seeing a binary-only driver on
> realtek.com.tw? That would definitely be a GPL violation, given that
> they use a modified version of the GPLed libipw stack.)


No driver at all. I looked at the Toshiba site, but found only Windows
drivers. Which OEM has the driver available?

Larry


