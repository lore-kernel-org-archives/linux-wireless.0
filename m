Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:18842 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbYK2Xoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 18:44:37 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1022107nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 29 Nov 2008 15:44:36 -0800 (PST)
Message-ID: <b3153e950811291544n409ac4a9vd6560bf7881224ff@mail.gmail.com> (sfid-20081130_004445_461155_0BD30F6D)
Date: Sat, 29 Nov 2008 15:44:35 -0800
From: "mohamed salim abbas" <mabbaswireless@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: iwl3945 rate control broken in wireless-testing
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87zljilcwi.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <87zljilcwi.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am looking into this. I will email a patch to fix this soon I hope by Tuesday.
Mohamed

On Sat, Nov 29, 2008 at 8:23 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Hello,
>
> rate control in iwl3945 from wireless-testing seems to have been
> broken for few weeks now, but I do not exactly when it exactly
> happened because my ADSL connection is usually the bottleneck.
>
> If I set the rate manually (for example iwconfig wlan0 rate 54M)
> correct rate is used, but with auto it doesn't rise from 1 Mbps. I
> thought Larry's fix for the pid rate-setting algorithm (commit
> d8dda0d5) would fix the problem, but that doesn't seem to be the case.
>
> I'm using iwl3945 and latest wireless-testing (commit 3b329bc4a) on
> Lenovo X60s running debian unstable 32bit. I don't have time to
> investigate this further, but I can test patches.
>
> --
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
