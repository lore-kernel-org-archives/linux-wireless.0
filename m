Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48186 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab0IRDhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 23:37:15 -0400
Received: by wwb31 with SMTP id 31so1687908wwb.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 20:37:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20100910T132509-455@post.gmane.org>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com>
	<69e28c911003061007y258ec349laa802810e0517de4@mail.gmail.com>
	<1267949782.15192.13.camel@mj>
	<69e28c911003070736t678cf6ccld0fe6dc332f4380d@mail.gmail.com>
	<1268190973.10669.12.camel@mj>
	<loom.20100910T132509-455@post.gmane.org>
Date: Sat, 18 Sep 2010 04:37:13 +0100
Message-ID: <AANLkTim4F8t2g8YGH8TKaudzAg42vzFgijcURUubVdkc@mail.gmail.com>
Subject: Re: Realtek rtl8188 support?
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Claus Ried <claus.ried@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 10, 2010 at 12:29 PM, Claus Ried <claus.ried@gmail.com> wrote:

> i have the same problems with an rtl8188su based usb wlan stick running on an
> amd64 based mandriva 2.6.33 kernel. The current staging drivers (inlcuding the
> firmware) do work to some extent, scanning is ok, listing surrounding wlans is
> working.
> But, i cannot connect to my wpa2 encrypted network using this stick.
> Everything is working fine if i am using the internal laptop wlan card (intel
> based).
> Any ideas why the usb stick won't connect?
> Claus

The Realtek vendor driver has always bundled its own wpa_supplicant
and I have wondered what mod they have made. Are you using your distro
wpa_supplicant or the Realtek vendor bundled one?
