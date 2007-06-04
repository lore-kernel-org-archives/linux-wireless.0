Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:55076 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbXFDUaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2007 16:30:05 -0400
Received: by py-out-1112.google.com with SMTP id a29so2515200pyi
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jun 2007 13:30:01 -0700 (PDT)
Message-ID: <43e72e890706041330yad26a1br2680593843375d66@mail.gmail.com>
Date: Mon, 4 Jun 2007 16:30:01 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>
Subject: Re: AW: Drivers that do not honor regulatory restrictions
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200706041428.25375.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <297494.10588.qm@web51404.mail.re2.yahoo.com>
	 <200706041428.25375.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/4/07, Holger Schurig <hs4233@mail.mn-solutions.de> wrote:
> > 1575         { 2412, 2484, 20, 6 } /* IEEE 802.11b/g, channels
> > 1..13 */,
> >
> > did the trick.
>
> Not sure if that is the right place .... but if you change the
> frequency, you should also change the comment:
>
>      /* IEEE 802.11b/g, channels 1..14 */
>
> would be better.

Regulatory domain code for mac80211 and in general for all Linux
wireless needs some work so expect to see this behavior to change. For
now drivers do their own work. Although mac80211 does some regulatory
work it is pretty basic and minimal.

  Luis
