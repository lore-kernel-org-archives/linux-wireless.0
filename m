Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:34167 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3FQXYm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 19:24:42 -0400
Received: by mail-qa0-f53.google.com with SMTP id g10so1769542qah.5
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 16:24:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmomOFZkr=-w6O1X_vq4=-jxJaSW429hu51ekEJf+1q-c-A@mail.gmail.com>
References: <CAJ-VmonxpTv0=5M6faG=UzswdH=c4+L1HYMXatnmssx1Rz7vLQ@mail.gmail.com>
 <CAGRGNgWJr=EahOWeQxpchCAyv5di-WnwyL9hvJa3XYFf64OSxg@mail.gmail.com> <CAJ-VmomOFZkr=-w6O1X_vq4=-jxJaSW429hu51ekEJf+1q-c-A@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 18 Jun 2013 09:24:21 +1000
Message-ID: <CAGRGNgU5Tr4oPctTiceSx=2bujs1dt2v-woCZSE-QJxEZ7xzFA@mail.gmail.com> (sfid-20130618_012445_739393_773C6ED6)
Subject: Re: ath3k hackery; doing it in userland
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adrian,

On 18 June 2013 05:05, Adrian Chadd <adrian@freebsd.org> wrote:
> On 16 June 2013 23:35, Julian Calaby <julian.calaby@gmail.com> wrote:
>
>> A further question: why isn't this in usb-modeswitch or some similar
>> "make my dumb USB device work" system?
>
> Well, there's a couple of hoops needed to jump through in order to
> make this thing work. It's not a "set this value to make it work",
> it's "upload this firmware blob to make this thing work."

Hence "some similar ...." - it's a dumb USB device - i.e. it boots up
as a device that's just smart enough to accept a firmware blob then,
as I recall from reading about their .... peculiarities, detaches and
reattaches with a different VID / PID when that firmware is loaded.

> I don't have any clue what the right order is to poke these BT devices
> (and even when i was working at QCA, finding documentation on the
> bluetooth devices was difficult!) and how they should behave. This
> whole "it detaches right after I load the sysconfig file" thing is
> quite annoying.

I believe the detaching is expected =(

Thanks,

--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
