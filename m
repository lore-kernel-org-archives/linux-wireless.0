Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59807 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab1KUNWR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 08:22:17 -0500
Received: by vcbfk1 with SMTP id fk1so5575248vcb.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 05:22:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK_tx3OP2UP=hv3gE-kwjrHbTqvHsWoeU44WRcVsw-KkJoVOkw@mail.gmail.com>
References: <CAFtRNNz6YEVp2efHqnh0aQ8DEdWm9-ztp8vRTmdorUjf8tJs5w@mail.gmail.com>
	<CAJ-Vmon3SsyQxOxpZxiCkbTJ60j-z7sXNgGUgiyAX9+-JzFMqQ@mail.gmail.com>
	<CAFtRNNxH-7kU-Pq939aFupdOHW0ofeU7Ddqwg5pBoCu2JQp1wg@mail.gmail.com>
	<CAJ-Vmo=o5=yqzp7+z2=aDe+4TqUAJ5yCCT_EP12o=CEJQqz-Vg@mail.gmail.com>
	<CAK_tx3OP2UP=hv3gE-kwjrHbTqvHsWoeU44WRcVsw-KkJoVOkw@mail.gmail.com>
Date: Mon, 21 Nov 2011 21:22:16 +0800
Message-ID: <CAJ-VmomWMcR88DxUWe4J851O7WeVNyy4UT9z5BVhOqZUDZ_yLw@mail.gmail.com> (sfid-20111121_142219_720060_9F556B59)
Subject: Re: A weird hw crypto bug...
From: Adrian Chadd <adrian@freebsd.org>
To: Albert Gall <ss3vdr@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 November 2011 19:16, Albert Gall <ss3vdr@gmail.com> wrote:
> The same problem described in this thread appear AR2414 hardware. Loading
> ath5k with nohwcrypt = 1 everything works fine, attached information and
> evidence that I hope will be useful.
> If you need more please just ask.

Well, what would be useful is figuring out why the frames are being
dropped in the first place.

Nick, did you get verification whether this is a bug with crypto TX, RX or both?


Adrian
