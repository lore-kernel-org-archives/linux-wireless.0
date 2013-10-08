Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:56500 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab3JHTV7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 15:21:59 -0400
Received: by mail-lb0-f177.google.com with SMTP id w7so7241041lbi.36
        for <linux-wireless@vger.kernel.org>; Tue, 08 Oct 2013 12:21:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOAOC6YGEphx+qo43hSWd=24knae_UC=JViTuiEUTT4TuGix4g@mail.gmail.com>
References: <CAOAOC6YT=ek4S=s0YNqejD2iCdPYng6FnJ1ROegwWhmcVZhyOg@mail.gmail.com>
	<CANUX_P25P2LwMwA3HRaxGBCkPsDTs6cOymkM5P+t7B8132CExA@mail.gmail.com>
	<CAOAOC6YGEphx+qo43hSWd=24knae_UC=JViTuiEUTT4TuGix4g@mail.gmail.com>
Date: Tue, 8 Oct 2013 22:21:57 +0300
Message-ID: <CANUX_P2ihGK4EVYqWgDeKg2AxeLtJsNiQg6aEo86Zgvh61ywGg@mail.gmail.com> (sfid-20131008_212201_816471_B42BAF4E)
Subject: Re: pci-half-mini 7206 ac/bluetooth issues
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Tim Nelson <tim.l.nelson@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 8, 2013 at 10:06 PM, Tim Nelson <tim.l.nelson@gmail.com> wrote:
>
> The first step works, I tested it for a couple of days with no issues.
>  I will test the power statement on it's own later today and let you
> know the results of it.
>

This is really weird... Please notice that new BT FW was published in
the last few days to linux-firmware.git. Can you please also try with
the new BT FW and without bt_coex_active=0?
Do you have the ability to use trace-cmd?
How long does it take to have wifi / bt die?
