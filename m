Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:61569 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbZIQM52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 08:57:28 -0400
Received: by iwn8 with SMTP id 8so179320iwn.4
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2009 05:57:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1214494232.20090917162242@mail.ru>
References: <1214494232.20090917162242@mail.ru>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 17 Sep 2009 05:57:10 -0700
Message-ID: <43e72e890909170557nf991a02n3e268f5c0e416fb0@mail.gmail.com>
Subject: Re: 2.6.25 kernel & compat-wireless-2009-09-14
To: Nikolai ZHUBR <zhubr@mail.ru>
Cc: linux-wireless@vger.kernel.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav Jauhar <gaurav.jauhar@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 17, 2009 at 6:22 AM, Nikolai ZHUBR <zhubr@mail.ru> wrote:
> Hello people,
>
> So finally I got it mostly working and usable as AP:
>
> Hardware:
> * ASUS WL-500gP (mips) with stock wireless card removed (broadcom).
> * New shining Ralink RT2600 Mini-PCI card
> Software:
> * kernel 2.6.25.20 (openwrt 8.09.1)
> * compat-wireless-2009-09-14 (without rfkill_backport and with ugly bus_id fix)
> libnl-1.1
> hostapd 0.6.9
>
> The led is now even blinking nicely.
> Strange though that selecting static IP in the client didn't work,
> but using DHCP works fine (it's ok for me now).

That's great! Care to send some patches for this?

  Luis
