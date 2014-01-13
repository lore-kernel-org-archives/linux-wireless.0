Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:42618 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaAMTEx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 14:04:53 -0500
Received: by mail-la0-f54.google.com with SMTP id y1so1450827lam.41
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 11:04:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389633805.5008.13.camel@jlt4.sipsolutions.net>
References: <1389385273-1322-1-git-send-email-a.gal@motsai.com>
	<1389620141.5008.8.camel@jlt4.sipsolutions.net>
	<CAN44aq1hrya4B4X4xTi4Aphb9QDBiQ9813kT6vhxtDCzBRoNhQ@mail.gmail.com>
	<1389633805.5008.13.camel@jlt4.sipsolutions.net>
Date: Mon, 13 Jan 2014 14:04:52 -0500
Message-ID: <CAN44aq2CAuF=Yx3YUvesagxSod=rNHq0sV98jeTQFoY1tHhFRg@mail.gmail.com> (sfid-20140113_200456_652152_09740072)
Subject: Re: [PATCH v5] wl12xx: fix tx power setting
From: Alex Gal <a.gal@motsai.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Luca Coelho <luca@coelho.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Oh, really? Ok. I didn't think that driver supported channel contexts.
> In that case your patch is right but incomplete - you should remove the
> CONF_CHANGE_POWER handling.

I think wlcore is used by both wl12xx and wl18xx.

It looks like wl18xx supports multiple channels and perhaps channel
contexts (?) while the wl12xx does not.

Luca, who is no longer the driver maintainer, might shed some light on this :)

I will recreate the patch afterwards by removing the CONF_CHANGE_POWER handling.

Thank you
