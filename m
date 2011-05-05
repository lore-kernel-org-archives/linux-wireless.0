Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39495 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab1EEP53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 11:57:29 -0400
Received: by iyb14 with SMTP id 14so1921662iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2011 08:57:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1304594478.3749.61.camel@wimaxnb>
References: <1304594478.3749.61.camel@wimaxnb>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 5 May 2011 08:57:09 -0700
Message-ID: <BANLkTimGs+hAX=5wE7PiTuVzD=4iLShBHQ@mail.gmail.com> (sfid-20110505_175733_237953_64C95B6B)
Subject: Re: wireless-regdb US and CA settings incorrect?
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	Michael Green <Michael.Green@atheros.com>
Cc: "ext John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 5, 2011 at 4:21 AM, Juuso Oikarinen
<juuso.oikarinen@nokia.com> wrote:
> Hi John, all,
>
> The following is an excerpt of the db.txt from most recent
> wireless-regdb.
>
> country US:
>         (2402 - 2472 @ 40), (3, 27)
>         (5170 - 5250 @ 40), (3, 17)
>         (5250 - 5330 @ 40), (3, 20), DFS
>         (5490 - 5600 @ 40), (3, 20), DFS
>         (5650 - 5710 @ 40), (3, 20), DFS
>         (5735 - 5835 @ 40), (3, 30)
>
> country CA:
>         (2402 - 2472 @ 40), (3, 27)
>         (5170 - 5250 @ 40), (3, 17)
>         (5250 - 5330 @ 40), (3, 20), DFS
>         (5490 - 5710 @ 40), (3, 20), DFS
>         (5735 - 5835 @ 40), (3, 30)
>
> We are under the understanding that the Canadian national rules deny the
> usage of the 5490-5710 range of frequencies (ref from RSS-210), but the
> range is present in the allowed range of frequencies for the CA region:
>
> "Additional requirements for the band 5600-5650 MHz: Until further
> notice, devices subject to this Section shall not be capable of
> transmitting in the band 5600-5650 MHz, so that Environment Canada
> weather radars operating in this band are protected."
>
> Then again, the FCC rules (15.407) do not prohibit the mentioned range
> of frequencies within the US (with DFS and limited power level) but in
> the regulatory database that range is missing.
>
>
> Is there a bug in the regulatory db, or am I misunderstanding something?


Michael, any opinion on this?

  Luis
