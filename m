Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42502 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298Ab2BIWC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 17:02:59 -0500
Received: by iacb35 with SMTP id b35so3099710iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 14:02:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK80WHbh13duicPjTEWpTpbjiCiJUu6R_ZArYce5D7wUu1PnMA@mail.gmail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
 <1327581484-22047-2-git-send-email-victorg@ti.com> <4F277E8D.5040809@sipsolutions.net>
 <CAK80WHbh13duicPjTEWpTpbjiCiJUu6R_ZArYce5D7wUu1PnMA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 9 Feb 2012 14:02:39 -0800
Message-ID: <CAB=NE6W9JdLDn7FRwuT9fEQUMs7Xkn4yyJzaYshzViGmzbBNTQ@mail.gmail.com> (sfid-20120209_230304_545879_226E44DB)
Subject: Re: [RFC 1/9] nl80211/cfg80211: add radar detection command/event
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 2, 2012 at 8:06 AM, Goldenshtein, Victor <victorg@ti.com> wrote:
> On Tue, Jan 31, 2012 at 7:39 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> Why DFS & radar detection? I mean, why not just call it CMD_RADAR_DETECT or
>> so?
>>
>
> will rename it to CMD_RADAR_DETECT

May want to also make the language a bit clearer on the description.

>>
>> How do you *end* radar detection? What channel does it apply to? Any channel
>> you're on? The channel you were on when it was enabled?
>
> Once we start radar detection, it should continuously monitor for
> radar until we switch from this channel. The command applies to
> current operational channel.

Please consider adding this to the documentation,  it would make this
crystal clear.

  Luis
