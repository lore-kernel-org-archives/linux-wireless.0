Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41761 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894Ab2BIXFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 18:05:05 -0500
Received: by iacb35 with SMTP id b35so3159675iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 15:05:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK80WHbESx0xtpp2LujPb2-+DXMCJ3NjC6e8KcHvcbKx2tJ7=A@mail.gmail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
 <1327581484-22047-7-git-send-email-victorg@ti.com> <4F27814A.9060906@sipsolutions.net>
 <CAK80WHZw9PRr_wjazJiPUo1vrCpjgyrSx9ydHwLGoJEp3qNwDA@mail.gmail.com>
 <1328562215.3466.3.camel@jlt3.sipsolutions.net> <CAK80WHbESx0xtpp2LujPb2-+DXMCJ3NjC6e8KcHvcbKx2tJ7=A@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 9 Feb 2012 15:04:44 -0800
Message-ID: <CAB=NE6V9Yk1OK0uMU=gyxHKuRmHqYdKi9KBmtz8hYhdcpgrhKQ@mail.gmail.com> (sfid-20120210_000510_554062_DCD49B77)
Subject: Re: [RFC 6/9] mac80211: add ap channel switch command/event
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 9, 2012 at 12:02 PM, Goldenshtein, Victor <victorg@ti.com> wrote:
> On Mon, Feb 6, 2012 at 11:03 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> When the driver doesn't explicitly implement channel switch for this and
>> other things, mac80211 could (should?) manage it.
>>
>
> I guess it can be implemented at some later point.

Then you need to ensure that a capability is checked and if this
capability is required but not available yet in mac80211 DFS cannot be
started.

  Luis
