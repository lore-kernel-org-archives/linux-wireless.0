Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:42730 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755400Ab2BIUCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:02:48 -0500
Received: by lagz14 with SMTP id z14so3293117lag.27
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 12:02:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328562215.3466.3.camel@jlt3.sipsolutions.net>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-7-git-send-email-victorg@ti.com>
	<4F27814A.9060906@sipsolutions.net>
	<CAK80WHZw9PRr_wjazJiPUo1vrCpjgyrSx9ydHwLGoJEp3qNwDA@mail.gmail.com>
	<1328562215.3466.3.camel@jlt3.sipsolutions.net>
Date: Thu, 9 Feb 2012 22:02:44 +0200
Message-ID: <CAK80WHbESx0xtpp2LujPb2-+DXMCJ3NjC6e8KcHvcbKx2tJ7=A@mail.gmail.com> (sfid-20120209_210251_587630_0CC51C18)
Subject: Re: [RFC 6/9] mac80211: add ap channel switch command/event
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 6, 2012 at 11:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> When the driver doesn't explicitly implement channel switch for this and
> other things, mac80211 could (should?) manage it.
>

I guess it can be implemented at some later point.


>> The mechanism is different from the client-side channel switch, but
>> the "ieee80211_channel_switch" struct is almost the same (new
>> post_switch_block_tx). Do you prefer to create a new
>> "ieee80211_ap_channel_switch" struct + new driver callback ? something
>> like drv_ap_channel_switch ?
>
> I think that would be cleaner in terms of API, since not all drivers
> will support both.
>

I will do that.

-- 
Thanks,
Victor.
