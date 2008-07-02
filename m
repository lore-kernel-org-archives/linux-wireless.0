Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:50777 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115AbYGBCl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 22:41:58 -0400
Message-ID: <486AEB44.9030704@lwfinger.net> (sfid-20080702_044205_495015_D51F92D1)
Date: Tue, 01 Jul 2008 21:43:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
References: <20080701225207.GB4292@khazad-dum.debian.net> <1214952993.3462.14.camel@johannes.berg> <20080701235747.GG4292@khazad-dum.debian.net>
In-Reply-To: <20080701235747.GG4292@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> On Wed, 02 Jul 2008, Johannes Berg wrote:
> I apologise.  Re-reading it, it does look like a rant, indeed.  It wasn't
> supposed to be, but the tone came up nasty and quite defensive.  I didn't
> intend it to.
> 
> The sheer ammount of explanations I have had to type over the whole rfkill
> business is, apparently, getting to me a lot more than expected, and I guess
> that put me in the defensive.  There is no excuse for that.
> 
> So, please accept my appologies on the tone of the last email.  Please
> reconsider reading that email in full, and please try to ignore the rantness
> smell in it.  I did try to explain the technical reasons why some changes
> would be needed in b43.
> 
> I am sorry I didn't send you any patches.  I don't have any access to a b43
> device, and as a rule, I try to avoid modifying code I will not be able to
> test, especially when I don't know the code to begin with and the changes
> are not going to be small, obvious ones.
> 
>> To address one point though: userspace does want a notification when the
>> hw-rfkill is activated so it (e.g. network manager) can ask people to
>> un-rfkill their device.
> 
> I tried to add such notifications directly to the rfkill class.  rfkill now
> issues uevents and calls a notification chain for any state changes.  It has
> been modified to differentiate hw-rfkill from sw-rfkill, and export that
> information to userspace for network-manager and other applications to use.

I am more than happy to test any b43 patches that you generate. My b43 
device has a wireless switch.

Larry
