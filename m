Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48499 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab0J3SLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Oct 2010 14:11:36 -0400
Received: by mail-vw0-f46.google.com with SMTP id 13so1466466vws.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Oct 2010 11:11:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101030144947.GA2058@tuxdriver.com>
References: <201010292202.25486.s.L-H@gmx.de> <694082.86488.qm@web56803.mail.re3.yahoo.com>
 <AANLkTimnuHM3E3G=d+R4-b=1NDkdEQ9jkbQsqB9ASiEC@mail.gmail.com>
 <4CCB99CB.9000400@lwfinger.net> <20101030144947.GA2058@tuxdriver.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 30 Oct 2010 20:11:14 +0200
Message-ID: <AANLkTi=WTFY07fqV5QsDcmzdL+0=4TQe7xv0ui90J=Jd@mail.gmail.com>
Subject: Re: Realtek rtl8188 support?
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Walter Goldens <goldenstranger@yahoo.com>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 30, 2010 at 4:49 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Oct 29, 2010 at 11:06:35PM -0500, Larry Finger wrote:
>> On 10/29/2010 04:27 PM, Gábor Stefanik wrote:
>> >
>> > AFAIK we only add staging drivers that will eventually move out of
>> > staging. r8712 has no chance of ever leaving staging; a completely new
>> > driver needs to be written (because it isn't mac80211-based).
>>
>> That is correct, but it should not be too long until there is a mac80211 driver
>> for that chip. I just got GPLd sources from Realtek for a mac80211-based driver
>> for the RTL8192CE PCIe device. It will need only a small amount of work to make
>> it ready for mainline. The critical part is that it uses the same chip as is
>> used in the RTL8712 USB device.
>
> Sounds like good news...
>
>> For those that are interested in the RTL8187SE, I'm told that they have a
>> working mac80211 driver for it, but that it is not yet stable.
>
> More good news!  Even if that device is aging, this indicates that
> Realtek is getting serious about working with the community, even on
> older devices.

However, it may be a good idea to indicate that "it is not yet stable"
AFAIK doesn't preclude inclusion...

>
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
