Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:21376 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYLOWZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 17:25:41 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2693443rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 14:25:41 -0800 (PST)
Message-ID: <69e28c910812151425x6e2cea07k81ecfaf457d3c144@mail.gmail.com> (sfid-20081215_232547_272335_8D9D695B)
Date: Mon, 15 Dec 2008 23:25:41 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Jason Self" <jason.self@gmail.com>
Subject: Re: Realtek wireless 8187se
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <b76df900812151414n21e21876q47c858f1c417a667@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <b76df900812151329x4309b264u7a017e4b4c2d8451@mail.gmail.com>
	 <69e28c910812151355l6549e8c2mea381a12663c7cb5@mail.gmail.com>
	 <b76df900812151413u32cdca95qd7122ca688a8a8d8@mail.gmail.com>
	 <b76df900812151414n21e21876q47c858f1c417a667@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 15, 2008 at 11:14 PM, Jason Self <jason.self@gmail.com> wro=
te:
> On Mon, Dec 15, 2008 at 2:13 PM, Jason Self <jason.self@gmail.com> wr=
ote:
>> On Mon, Dec 15, 2008 at 1:55 PM, Stefanik G=E1bor <netrolller.3d@gma=
il.com> wrote:
>>>
>>> Looks like this is a MiniPCIE card, so the chip is essentially an
>>> RTL8187 or RTL8187B with the USB communication part replaced with a
>>> PCI Express one. Given the existence of this open-source driver,
>>> adding support for it into rtl818x should not really be a problem.
>>
>> That sounds wonderful. Would it still be helpful if I opened the
>> laptop to determine what is printed on the chip itself?

No, it is not needed anymore, as the driver you posted confirms that
it is indeed a new device.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
