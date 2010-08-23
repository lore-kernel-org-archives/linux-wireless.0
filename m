Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63600 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab0HWX42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 19:56:28 -0400
Received: by qwh6 with SMTP id 6so5590548qwh.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 16:56:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C730173.7080703@lwfinger.net>
References: <1282506589-8220-1-git-send-email-zajec5@gmail.com>
 <AANLkTi=TMhmTF+ztooAu=E1e1zdw-cBnaSZCKj=Utik0@mail.gmail.com>
 <AANLkTikMxL41zrR+KDF1Od_SKpbQhsQWHWiAAAULYx+F@mail.gmail.com>
 <AANLkTim6d0C_Lx=zExfHy-hfeVdY=aXZCfi6c825TGt7@mail.gmail.com> <4C730173.7080703@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 24 Aug 2010 01:56:06 +0200
Message-ID: <AANLkTik8cMdxG-0azPOsoBEMdf1JkZ_Gemh_bNDSF3sS@mail.gmail.com>
Subject: Re: [PATCH 1/2] b43: N-PHY: band width setting with dumb clock
 control call
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 24, 2010 at 1:17 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 08/23/2010 05:53 PM, Rafał Miłecki wrote:
>>> I believe you need to do the whole PHY init, including the common
>>> part; not just the PHY type-specific init. Larry, is this true?
>>
>> Do you mean b43_phy_init? Larry: I guess indeed some tip would be nice :)
>
> As it shows in http://bcm-v4.sipsolutions.net/802.11/PHY/Init, you need to do
> the Common steps. #15 in that list is the specific routines for the PHY type in
> the device.
>
> The code in b43_phy_init() seems not to have all of these steps in it, but I'm
> not sure where they are implemented.

This spec page seems to have lots of Broadcrap in it... it especially
needs de-chanspec-tamination; how the driver handles band and
bandwidth selection is irrelevant to a HW specification. (Also, many
referenced chanspec-related functions are missing.)

>
> Larry
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
