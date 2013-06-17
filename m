Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f48.google.com ([209.85.128.48]:42514 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab3FQTF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 15:05:29 -0400
Received: by mail-qe0-f48.google.com with SMTP id 2so1892276qea.7
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 12:05:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgWJr=EahOWeQxpchCAyv5di-WnwyL9hvJa3XYFf64OSxg@mail.gmail.com>
References: <CAJ-VmonxpTv0=5M6faG=UzswdH=c4+L1HYMXatnmssx1Rz7vLQ@mail.gmail.com>
	<CAGRGNgWJr=EahOWeQxpchCAyv5di-WnwyL9hvJa3XYFf64OSxg@mail.gmail.com>
Date: Mon, 17 Jun 2013 12:05:29 -0700
Message-ID: <CAJ-VmomOFZkr=-w6O1X_vq4=-jxJaSW429hu51ekEJf+1q-c-A@mail.gmail.com> (sfid-20130617_210532_936726_65D98D1F)
Subject: Re: ath3k hackery; doing it in userland
From: Adrian Chadd <adrian@freebsd.org>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 June 2013 23:35, Julian Calaby <julian.calaby@gmail.com> wrote:

> A further question: why isn't this in usb-modeswitch or some similar
> "make my dumb USB device work" system?

Well, there's a couple of hoops needed to jump through in order to
make this thing work. It's not a "set this value to make it work",
it's "upload this firmware blob to make this thing work."

I don't have any clue what the right order is to poke these BT devices
(and even when i was working at QCA, finding documentation on the
bluetooth devices was difficult!) and how they should behave. This
whole "it detaches right after I load the sysconfig file" thing is
quite annoying.



adrian
