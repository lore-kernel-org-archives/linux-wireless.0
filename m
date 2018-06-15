Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dnvrco-outbound-snat.email.rr.com ([107.14.73.231]:61237 "EHLO
        dnvrco-cmomta02.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756320AbeFOQ6k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 12:58:40 -0400
Message-ID: <20180615165838.QFYTH.206966.root@dnvrco-web09> (sfid-20180615_185843_407947_1C6BDC74)
Date: Fri, 15 Jun 2018 16:58:38 +0000
From: <mgreger@cinci.rr.com>
To: =?utf-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Subject: Re: Atheros AR9462 - 5Ghz not working
Cc: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        sedat.dilek@gmail.com
In-Reply-To: <CABvG-CXfF50vsJaWmygjbEyq9HWZG5xaqHKvEQVP31sGx441kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---- "Michał Kazior" <kazikcz@gmail.com> wrote: 
> Your noise floor readout in survey dump is terribly bad for 5GHz. It
> ain't stellar for 2.4GHz either but within reason nonetheless.
> 
> Did you try using the card in a different device? I wonder if the
> device you're trying to use it in has some sort of internal noise on
> those frequencies and/or ath9k's ANI isn't able to deal with it.
> 
> 
> Michał
> 
> On 15 June 2018 at 15:31,  <mgreger@cinci.rr.com> wrote:


I did.
I took it out of the Penguin-Z notebook and put it in a Dell XPS15 9560 running Windows 10. Only 2.4Ghz networks were visible from there as well. Not exactly apples-to-apples, but consistent results.
