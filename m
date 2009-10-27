Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:46963 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbZJ0BiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 21:38:17 -0400
Received: by iwn10 with SMTP id 10so6376237iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 18:38:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910270259.09787.denys@visp.net.lb>
References: <200910270259.09787.denys@visp.net.lb>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Oct 2009 18:38:02 -0700
Message-ID: <43e72e890910261838k7986048dg4cc38634d828e98c@mail.gmail.com>
Subject: Re: ath5k, too high output power?
To: Denys Fedoryschenko <denys@visp.net.lb>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 26, 2009 at 5:59 PM, Denys Fedoryschenko <denys@visp.net.lb> wrote:
> I have laptop with ath5k card, and just tried to run it with ath5k driver.
> I notice strange thing:
>
> lappi ~ # iw phy phy0 info
> Wiphy phy0
>        Band 1:
>                Frequencies:
>                        * 2412 MHz [1] (20.0 dBm)
>                        * 2417 MHz [2] (20.0 dBm)
>                        * 2422 MHz [3] (20.0 dBm)
>
> I guess it is too high. I am not sure it is actual value, but if it is right
> and actual value, then i am exceeding local regulations.

That value is the maximum value allowed, not your actual eirp. By
default the EEPROM's card is read and that is used for regulatory
purposes, users can however be good citizens and help regulatory
compliance further by indicating their country and if the max eirp of
the programmed EEPROM is higher than your current country it will be
lowered.

Please have a good read at:

http://wireless.kernel.org/en/developers/Regulatory
http://wireless.kernel.org/en/users/Drivers/ath

> Another thing, is it possible to change antenna output?

You obviously can change the antenna on a lot of devices, sometimes
that is difficult due to the connectors used but you are likely to
find them online somewhere.

  Luis
