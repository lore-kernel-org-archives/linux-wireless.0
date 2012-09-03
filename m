Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53333 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab2ICUDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 16:03:51 -0400
Message-ID: <50450D23.3010904@lwfinger.net> (sfid-20120903_220409_160285_85727E81)
Date: Mon, 03 Sep 2012 15:03:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove bogus memcpy in brcm80211 ai_detach
References: <20120903191335.GW16230@one.firstfloor.org> <50450388.6040506@lwfinger.net> <20120903195700.GZ16230@one.firstfloor.org>
In-Reply-To: <20120903195700.GZ16230@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/03/2012 02:57 PM, Andi Kleen wrote:
> On Mon, Sep 03, 2012 at 02:22:48PM -0500, Larry Finger wrote:

>> Have you compiled all of wireless with gcc 4.8? If so, can I assume that
>> you will report warnings for other drivers?
>
> I did 64bit allyesconfig with LTO yes.  wireless has very few warnings overall,
> compared to many other subsystems.
>
> I found one other issue in it for which I'm sending a patch.

Thanks for responding, and for doing the cleanup.

Larry



