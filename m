Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f197.google.com ([209.85.212.197]:64951 "EHLO
	mail-vw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661AbZLCJWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 04:22:10 -0500
MIME-Version: 1.0
In-Reply-To: <20091203085717.GO9121@core.coreip.homeip.net>
References: <1259826317-18809-28-git-send-email-corentincj@iksaif.net>
	 <1259826317-18809-30-git-send-email-corentincj@iksaif.net>
	 <1259826317-18809-31-git-send-email-corentincj@iksaif.net>
	 <1259826317-18809-32-git-send-email-corentincj@iksaif.net>
	 <1259826317-18809-33-git-send-email-corentincj@iksaif.net>
	 <20091203075404.GK9121@core.coreip.homeip.net>
	 <71cd59b00912030012r2f45f474u37c494ad281230cb@mail.gmail.com>
	 <20091203082120.GL9121@core.coreip.homeip.net>
	 <71cd59b00912030051w6bf54abfv726f288c2eae1d33@mail.gmail.com>
	 <20091203085717.GO9121@core.coreip.homeip.net>
Date: Thu, 3 Dec 2009 10:22:16 +0100
Message-ID: <71cd59b00912030122n3d94236ajfa5e55c3b5a9efcd@mail.gmail.com>
Subject: Re: [PATCH 32/33] input: add KEY_WIRELESS_CYCLE
From: Corentin Chary <corentin.chary@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-input@vger.kernel.org, networkmanager-list@gnome.org,
	linux-wireless@vger.kernel.org, kde-hardware-devel@kde.org,
	dbus@lists.freedesktop.org, hal@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 3, 2009 at 9:57 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Thu, Dec 03, 2009 at 09:51:59AM +0100, Corentin Chary wrote:
>> On Thu, Dec 3, 2009 at 9:21 AM, Dmitry Torokhov
>> <dmitry.torokhov@gmail.com> wrote:
>> > On Thu, Dec 03, 2009 at 09:12:52AM +0100, Corentin Chary wrote:
>> >> On Thu, Dec 3, 2009 at 8:54 AM, Dmitry Torokhov
>> >> <dmitry.torokhov@gmail.com> wrote:
>> >> > On Thu, Dec 03, 2009 at 08:45:16AM +0100, Corentin Chary wrote:
>> >> >> This keycode could be used in a lot of platform specific drivers.
>> >> >> For example, on Asus laptops, Fn+F2 allow to cycle trought wireless
>> >> >> drivers (bt/wl: off/off, on/off, off/on, on/on).
>> >> >>
>> >> >> Currently, these key are mapped to KEY_WLAN, and KEY_BLUETOOTH/KEY_WIMAX
>> >> >> are rarely used.
>> >> >>
>> >> >
>> >> > Is there any application support for such cycling? IOW does anyone cares
>> >> > to do such cycling?
>> >>
>> >> On Asus laptops (both asus and eeepc) the Fn+F2 key cycle
>> >> (bluetooth/wlan: on/on, on/off, off/on, off/off) on windows.
>> >> On Linux, it only produces a KEY_WLAN keycode.
>> >>
>> >
>> > I understand this. I guess the question is whether people working on
>> > system infrastructure (dbus, Networkmanager, etc) care about having such
>> > functionality on Linux? The reason I am asking is that we added all
>> > KEY_WIMAX and so on defines but I am not usre if anyone wants them.
>>
>> KEY_WIMAX may not be used a lot because there is not a lot of device
>> with such a key,
>> I think this is not the case for KEY_WIRELESS_CYCLE.
>>
>> The bad thing is that we will need to patch X11 (and Qt, for
>> kde/solid) to make it works.
>>
>> Maybe we should Cc dbus/network manager/solid/linux-wireless ?
>>
>
> That would be a good idea.

Here it is.

Dear system infrastructure people,
Do you think a KEY_WIRELESS_CYCLE key would have any application ?

-- 
Corentin Chary
http://xf.iksaif.net
