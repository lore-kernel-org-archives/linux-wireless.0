Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45318 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0IRXCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Sep 2010 19:02:40 -0400
Received: by wwb39 with SMTP id 39so2188000wwb.1
        for <linux-wireless@vger.kernel.org>; Sat, 18 Sep 2010 16:02:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim4F8t2g8YGH8TKaudzAg42vzFgijcURUubVdkc@mail.gmail.com>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com>
	<69e28c911003061007y258ec349laa802810e0517de4@mail.gmail.com>
	<1267949782.15192.13.camel@mj>
	<69e28c911003070736t678cf6ccld0fe6dc332f4380d@mail.gmail.com>
	<1268190973.10669.12.camel@mj>
	<loom.20100910T132509-455@post.gmane.org>
	<AANLkTim4F8t2g8YGH8TKaudzAg42vzFgijcURUubVdkc@mail.gmail.com>
Date: Sat, 18 Sep 2010 16:02:39 -0700
Message-ID: <AANLkTikSPf=VfcZEkTbwfZrfjgrtHe6_O0wXwWnz9g88@mail.gmail.com>
Subject: Re: Realtek rtl8188 support?
From: Paul Thomas <pthomas8589@gmail.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Claus Ried <claus.ried@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 17, 2010 at 8:37 PM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> On Fri, Sep 10, 2010 at 12:29 PM, Claus Ried <claus.ried@gmail.com> wrote:
>
>> i have the same problems with an rtl8188su based usb wlan stick running on an
>> amd64 based mandriva 2.6.33 kernel. The current staging drivers (inlcuding the
>> firmware) do work to some extent, scanning is ok, listing surrounding wlans is
>> working.
>> But, i cannot connect to my wpa2 encrypted network using this stick.
>> Everything is working fine if i am using the internal laptop wlan card (intel
>> based).
>> Any ideas why the usb stick won't connect?
>> Claus
>
> The Realtek vendor driver has always bundled its own wpa_supplicant
> and I have wondered what mod they have made. Are you using your distro
> wpa_supplicant or the Realtek vendor bundled one?

So this is working for me now. I'm using the r8712u driver from here:
http://git.kernel.org/?p=linux/kernel/git/lwfinger/r8712u.git;a=summary

With debian's wpa_supplicant v0.6.4.

thanks,
Paul
