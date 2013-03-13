Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:51367 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910Ab3CMPp0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 11:45:26 -0400
Received: by mail-wg0-f52.google.com with SMTP id 15so86113wgd.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2013 08:45:25 -0700 (PDT)
From: "Alessandro Lannocca" <alessandro.lannocca@gmail.com>
To: "'Larry Finger'" <Larry.Finger@lwfinger.net>
Cc: <linux-wireless@vger.kernel.org>
References: <000001ce1ffd$0ecd5e10$2c681a30$@gmail.com> <51409A73.9050107@lwfinger.net>
In-Reply-To: <51409A73.9050107@lwfinger.net>
Subject: R: rtl8192cu gets confused when scan is aborted by bringing interface down (Re: rtl8192cu goes silent/dead after some time...)
Date: Wed, 13 Mar 2013 16:45:23 +0100
Message-ID: <000001ce2001$c7252700$556f7500$@gmail.com> (sfid-20130313_164531_864500_9A195138)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I understand this bugs are lower priority, It's just a huge step forward to have this card in a working state, we'll wait for the rest to get sorted whenever possible.

Thanks

Alessandro Lannocca

-----Messaggio originale-----
Da: Larry Finger [mailto:larry.finger@gmail.com] Per conto di Larry Finger
Inviato: mercoledì 13 marzo 2013 16.26
A: Alessandro Lannocca
Cc: 'Jussi Kivilinna'; linux-wireless@vger.kernel.org; 'George0505'
Oggetto: Re: rtl8192cu gets confused when scan is aborted by bringing interface down (Re: rtl8192cu goes silent/dead after some time...)

On 03/13/2013 10:11 AM, Alessandro Lannocca wrote:
> Hi, some months ago I reported some bugs about this chipset; now I tried latest stable compat-drivers (3.9-rc2-2-su) with the modified patch by Jussi Kivilinna, and I'm happy to report that it works  with my alfa AWUS036NHR on ubuntu 12.10 with kernel 3.5; The card now sustains multiple connection/disconnection cicles, and doesn't go mute, even after changing mac address.
>
> Some problems still remains:
>
> -led is always solid, no blinking whatsoever.
> -in monitor mode, every client appears as not associated, even when it really is.
> -power/signal strength readings (in networkmanager) seem to be fuzzy, 
> almost inverse; nearest APs have lowest signal representation, while 
> farest ones get strongest signal (this could very well be a 
> networkmanager bug/misrepresentation); signal appears normal when the 
> card is connected (only the reading relative to the connected AP)
>
> I know you're probably understaffed and have a lot of work to do, however if you're willing to have a look at this secondary problems (Mr. Finger perhaps), I'm willing to recompile, test and report back to help squash these bugs.
>
> I'm attaching a debug=5 log to show my tests.
>
> As of now, this chipset/card is usable (signal reading is annoying 
> btw)

Thanks for the report. That patch will be pushed upstream in a few minutes and will be backported to stable withing a few weeks. I am happy to hear that the patch works with your Alfa AWUS036NHR. In my limited testing with that device, it failed to connect. I feared that the RTL8192RU differed from the RTL8192CU.

I know that improper operation of the LEDs and screwy signal levels are annoying, and I will get to them when I can. At the moment, however, I have more important problems to solve.

Thanks,

Larry



