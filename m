Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:39650 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106Ab2BBQHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 11:07:10 -0500
Received: by wibhm2 with SMTP id hm2so3292149wib.16
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 08:07:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F278050.8030407@sipsolutions.net>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-6-git-send-email-victorg@ti.com>
	<4F278050.8030407@sipsolutions.net>
Date: Thu, 2 Feb 2012 18:07:08 +0200
Message-ID: <CAK80WHYob-weoHCu=5uGApffwxz+2zxWH9Jm9ssOomi5Vi9HvA@mail.gmail.com> (sfid-20120202_170715_113160_C7266C07)
Subject: Re: [RFC 5/9] nl80211/cfg80211: add ap channel switch command/event
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

On Tue, Jan 31, 2012 at 7:46 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On 1/26/2012 4:38 AM, Victor Goldenshtein wrote:
>>
>> Add new NL80211_CMD_AP_CHANNEL_SWITCH command which
>> triggers a channel switch process, this command also
>> notifies usermode about channel switch complete event.
>
>
> I think this needs a little more explaining how it would be used with
> hostapd adding the channel switch IEs into the beacon.
>

Will add additional explanation.

-- 
Thanks,
Victor.
