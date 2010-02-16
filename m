Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f187.google.com ([209.85.222.187]:59227 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665Ab0BPUUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 15:20:19 -0500
Received: by pzk17 with SMTP id 17so5438740pzk.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 12:20:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100216201026.25148.40799.stgit@tikku>
References: <20100216201026.25148.40799.stgit@tikku>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 16 Feb 2010 12:19:58 -0800
Message-ID: <43e72e891002161219u2916f735l6325f7e7054fa5e2@mail.gmail.com>
Subject: Re: [RFC PATCH] nl80211: add power save commands
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 16, 2010 at 12:10 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> From: Kalle Valo <kalle.valo@nokia.com>
>
> The only missing command from nl80211, which Wireless Extensions had,
> was support for power save mode.

BTW I actually found another which is missing to be complete to wext:

iwconfig wlan0 txpower 17

I guess I should take care of that since I'm the regulatory dork.

> Add a simple command to make it possible
> to enable and disable power save.

Thanks a lot for this.

  Luis
