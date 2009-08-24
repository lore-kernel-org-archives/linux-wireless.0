Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:37840 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbZHXVDe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 17:03:34 -0400
Received: by ewy3 with SMTP id 3so2780783ewy.18
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2009 14:03:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908241510.10968.herton@mandriva.com.br>
References: <200908220038.35564.herton@mandriva.com.br>
	 <3ace41890908221459j70e31c20ufa5ea03973a16e0a@mail.gmail.com>
	 <3ace41890908231238h32b85839qe74bce2852103402@mail.gmail.com>
	 <200908241510.10968.herton@mandriva.com.br>
Date: Mon, 24 Aug 2009 22:03:35 +0100
Message-ID: <3ace41890908241403x31579c79x226fee6a6cd06e5b@mail.gmail.com>
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 24, 2009 at 7:10 PM, Herton Ronaldo
Krzesinski<herton@mandriva.com.br> wrote:
<snipped>
> This is strange, may be NetworkManager does something extra and for some reason
> manages to wake up the interface again? I thought it would be unable to "if up"
> the interface since -ERFKILL should be returned to it when switch is off...
>
>>
>> Is this intentional? I thought it is supposed to actually switch off
>> the hardware, or is this how the code supposed to work?
>> Maybe some component needs to let NM knows not to reenanble the device.
>
> About taking interface down, thats expected, but I don't know about
> NetworkManager, I was expecting it to be unable to "if up" the interface again.

Is there a minimum version of NM/wpa_supplicant  this is expected? I
could upgrade if needed to. I am mostly fedora 11 based and have NM
0.7.1-8.git20090708 , wpa_supplicant 0.6.8.

Hin-Tak
