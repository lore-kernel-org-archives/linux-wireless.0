Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52771 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab0HIX6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Aug 2010 19:58:36 -0400
Received: by eya25 with SMTP id 25so3628841eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Aug 2010 16:58:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C5EFCC1.4070106@candelatech.com>
References: <AANLkTi=W=vkgb0gM7ZWsBeE79Fe3iabtKFgu2S7N5uLe@mail.gmail.com>
	<201008011137.49528.florian@openwrt.org>
	<AANLkTik=t=jeCG7=bgkq3LBwJP9vq7KmFpgDeHngPoq-@mail.gmail.com>
	<4C55F377.6040404@candelatech.com>
	<AANLkTi=FEFrKdXUHN-h-BZruvNzSmwXdPcq9-OgZcFAM@mail.gmail.com>
	<4C565100.4040305@candelatech.com>
	<AANLkTim8i245P0nGcnpsf63_O8xXeby9re=pX53WfOwV@mail.gmail.com>
	<AANLkTi=Krfwcmn6v7e6jU87A4cM3H06LTU7_XOiB-WUx@mail.gmail.com>
	<4C5EFCC1.4070106@candelatech.com>
Date: Tue, 10 Aug 2010 09:58:34 +1000
Message-ID: <AANLkTimaA-fgkfQQ1k77ticvXVpOCvaja-twOSKTpe=Y@mail.gmail.com>
Subject: Re: virtual access poitns (ath5k/mac80211)
From: Ryszard <ryszard99@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Florian Fainelli <florian@openwrt.org>,
	Patrick McHardy <kaber@trash.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

thanks for the info.  FWIW, it did install correctly, its just not
configured correctly and i was hoping you had a tip.  no worries, i'll
do a bit more searching.  i'm not putting it on a live CD, just trying
to install it on a running system.

OAN, could it be worth it if i attempted to integrate your patches
with a later rev of the kernel? i'm not terribly experienced with it,
but perhaps could make some progress with a little guidance.

On 9 August 2010 04:51, Ben Greear <greearb@candelatech.com> wrote:
> On 08/06/2010 10:23 PM, Ryszard wrote:
>>
>> hey ben,
>>
>> i've spend a day attempting to get the kernel installed but am not
>> having much luck.. the box i'm installing on is an alix
>> (http://www.pcengines.ch/alix2d13.htm, amd geode) which has an ubuntu
>> lucid kernel on it.
>
> For whatever reason, you didn't seem to install the kernel properly.
> If you're trying to put this on a live-cd, then you have too mess with
> the initrd...do some google searching on ubuntu's wiki.
>
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
