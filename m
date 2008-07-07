Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:52503 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbYGGW0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 18:26:07 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1054850ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 15:26:00 -0700 (PDT)
Message-ID: <1ba2fa240807071525m222efa91uf2ed009eb7b039b5@mail.gmail.com> (sfid-20080708_002612_572710_E45278A7)
Date: Tue, 8 Jul 2008 01:25:59 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [Rt2400-devel] rt2500pci: Failed to initialize hw. But works with ancient rt2500-1.1.0
Cc: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>,
	rt2400-devel@lists.sourceforge.net,
	"Stefan Bauer" <stefan.bauer@cs.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200807072319.44733.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de>
	 <200807072308.57529.IvDoorn@gmail.com>
	 <69e28c910807071410h17cd6815jd6577673f73dc092@mail.gmail.com>
	 <200807072319.44733.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 8, 2008 at 12:19 AM, Ivo van Doorn <ivdoorn@gmail.com> wrot=
e:
> On Monday 07 July 2008, Stefanik G=E1bor wrote:
>> On Mon, Jul 7, 2008 at 11:08 PM, Ivo van Doorn <ivdoorn@gmail.com> w=
rote:
>> > Check if the arc4 and ecb modules are loaded before loading mac802=
11 & rt2500pci.
>> >
>> > Ivo
>>
>> Shouldn't we make mac80211 depend on arc4 and ecb?
>
> They do depend on those modules, but for some reason they
> are not always automatically loaded when the mac80211 module is loade=
d.

This is bug is reported very often mostly on ubuntu based distoros.
There is no linkage dependency so it doesn't produce entry in the
depmod.
mac should somehow request these modules dynamically. If I understand
correctly is not so straight forward since there might be alternative
hw acceleration modules for  these modules.

Thanks
Tomas
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
