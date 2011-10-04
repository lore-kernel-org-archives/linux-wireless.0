Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39342 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab1JDHmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 03:42:07 -0400
Received: by gyg10 with SMTP id 10so190312gyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 00:42:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111001145007.GA2094@loiseau.cc>
References: <20111001145007.GA2094@loiseau.cc>
Date: Tue, 4 Oct 2011 09:42:06 +0200
Message-ID: <CAGXE3d-4Oqvyt8gS0WPsu1uyTyjoodTJ_fi=HdABkF2Jti_aLw@mail.gmail.com> (sfid-20111004_094211_878494_772469C4)
Subject: Re: rt2800pci - ksoftirq takes 100% CPU
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Loiseau Lucien <loiseau.lucien@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 1, 2011 at 4:50 PM, Loiseau Lucien <loiseau.lucien@gmail.com> wrote:
> Hi there,
>
> I experience some trouble with my RaLink RT3090 Wireless 802.11n 1T/1R
> PCIe card. I'm trying to set a wireless access point with it. I'm
> running a Debian Squeeze with kernel 2.6.32-5-686.
>
> at first i was using the shipped rt2860sta but since it's not a mac80211
> driver, i couldn't use hostapd and iwconfig mode master was not working.
> I eventually installed different stable version of compat-wireless and
> ran the driver rt2800pci. If i could set a running access  point, i
> often end with an unloadable module whith a ksoftirq taking 100% of my
> CPU. Once this "ksoftirq" problem arises, there is no way to  unload the
> module.
>
> does anyone ever experience this card and make it work fine ?
> I can provide more information if needed.

Could you please check if you have [1] applied?

Thanks,
Helmut

[1] http://permalink.gmane.org/gmane.linux.kernel.wireless.general/74494
