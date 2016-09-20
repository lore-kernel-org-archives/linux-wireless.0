Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45240 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752132AbcITUMZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 16:12:25 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: "Franc\[e\]sco" <lolisamurai@waifu.club>
Cc: linux-wireless@vger.kernel.org
Subject: Re: RTL8192EU on rtl8xxxu driver breaks every few minutes
References: <c6784dde-65df-87cd-f97e-33fbd8dd55ff@waifu.club>
Date: Tue, 20 Sep 2016 16:12:23 -0400
In-Reply-To: <c6784dde-65df-87cd-f97e-33fbd8dd55ff@waifu.club> (Franc[e]sco's
        message of "Mon, 19 Sep 2016 21:42:55 +0200")
Message-ID: <wrfj4m5acouw.fsf@redhat.com> (sfid-20160920_221228_402925_C51C0E79)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Franc[e]sco" <lolisamurai@waifu.club> writes:
> Hi, I happen to own a RTL8192EU WiFi dongle which is marked as untested
> by the rtl8xxxu driver.
>
> I'm on a linux from scratch system using kernel 4.7.3 and wpa_supplicant
> 2.5.
>
> The dongle appears to connect and work fine, but after around 10 minutes
> it deauthenticates and enters and endless loop of authentication
> timeout. This continues even if I bring the interface down and back up
> again. The only way to restore the connection is to physically remove
> and re-plug the usb dongle.
>
> I have attached a dmesg log of connecting and entering the auth loop.

Please provide details about the AP you are trying to connect to and iw
link output.

Jes
