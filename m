Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:48884 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbXKVViE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 16:38:04 -0500
From: Chr <chunkeey@web.de>
To: developers@islsm.org
Subject: Re: [Developers] ISL3880IK crashes with 2.6.19.1 / .21.1
Date: Thu, 22 Nov 2007 22:35:43 +0100
Cc: Jan Willies <jan@willies.info>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, kyle@mcmartin.ca,
	linux-wireless@vger.kernel.org
References: <46631BD2.20704@willies.info> <43e72e890711211713y1678bc9blf75e45dae4d74b8@mail.gmail.com> <4745EE3E.8090601@willies.info>
In-Reply-To: <4745EE3E.8090601@willies.info>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711222235.44079.chunkeey@web.de> (sfid-20071122_213812_269375_704961E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Hmmz, I wasn't aware that p54 doesn't support encryption or AP mode yet.
> Is there any website/blog or something apart from linvilles commit log
> where I can read about its progress?
>
> Funny thing is, I had a chat with Michael Wu because p54 was segfaulting
> for me. Turned out that I was missing some crypto modules, which are
> only needed for encryption I guess. Therefore I assumed encryption is
> working.
>
"hardware encryption" does not work, since no one has implemented it.
but the software encryption is always available...

The AP Mode is a pain... Beause the firmware of the device changes the beacon
frames and does some accouting for the powersaving features...
There're workarounds, but they'll probably break something else.

Regards,
	Chr
