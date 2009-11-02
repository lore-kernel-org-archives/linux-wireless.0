Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:46055 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbZKBTek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 14:34:40 -0500
Received: by iwn10 with SMTP id 10so3567793iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2009 11:34:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <44491.72003.qm@web57906.mail.re3.yahoo.com>
References: <43e72e890911020945n7590b287je116d50561095980@mail.gmail.com>
	<44491.72003.qm@web57906.mail.re3.yahoo.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 2 Nov 2009 11:34:23 -0800
Message-ID: <43e72e890911021134s91ae1bbw49cabfb970f82fc6@mail.gmail.com>
Subject: Re: May I join ath9k_htc update 2009-10-28
To: hong zhang <henryzhang62@yahoo.com>
Cc: Christian Lamparter <chunkeey@web.de>,
	devel@linuxdriverproject.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Chen <Stephen.Chen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 2, 2009 at 11:26 AM, hong zhang <henryzhang62@yahoo.com> wrote:
> TL-WN721N is not 11n complied.

Huh? TL-WN721N should be ar9271 hardware. All ar9271 devices are
single stream devices which means the highest MCS rate is MCS 7. I
forget but I believe 11n wifi cert accepts single stream devices now.

> TL-WN821N complies with 11n.

As per Christian it seems this is an ar9170 device, which is dual
stream and using the older Atheros hardware. It certainly has capacity
to TX/RX more but remember that it is more expensive too. Single
stream devices bring 802.11n hardware price down to a competitive
level and kill 802.11g :)

  Luis
