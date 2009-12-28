Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39511 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZL1Qqs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2009 11:46:48 -0500
Received: by ewy19 with SMTP id 19so1950769ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 28 Dec 2009 08:46:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <83a869cd0912091425h4c1f2815m71c9b4fa6f0954df@mail.gmail.com>
References: <83a869cd0908211513k2e14ba40k251aa8a1e7393a77@mail.gmail.com>
	 <1250927141.23605.3.camel@johannes.local>
	 <83a869cd0911071010g32c798c6pfecd875a1bf484e0@mail.gmail.com>
	 <1257621757.29454.48.camel@johannes.local>
	 <83a869cd0911161353p5ea44472s8e6f146929ff6c65@mail.gmail.com>
	 <1258408565.32159.42.camel@johannes.local>
	 <83a869cd0912071306y4a56953fm8248b6d030b311ae@mail.gmail.com>
	 <83a869cd0912091421s62b704f6wae023c61cab85e92@mail.gmail.com>
	 <83a869cd0912091425h4c1f2815m71c9b4fa6f0954df@mail.gmail.com>
Date: Mon, 28 Dec 2009 17:46:46 +0100
Message-ID: <83a869cd0912280846r5caccfc8s764148f8939be469@mail.gmail.com>
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: gregor kowski <gregor.kowski@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 12/9/09, gregor kowski <gregor.kowski@gmail.com> wrote:
> The mac80211 tkip code won't call update_tkip_key, if rx packets
> are received without KEY_FLAG_UPLOADED_TO_HARDWARE. This can happen on
> first packet because the hardware key stuff is called asynchronously with
> todo workqueue.
>
> This patch workaround that by tracking if we sent the key to the driver.
>
What's the status of this patch ?

Regards,

Gregor
