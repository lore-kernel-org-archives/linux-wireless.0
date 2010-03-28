Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39476 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab0C1XqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 19:46:19 -0400
Received: by pwi5 with SMTP id 5so6191030pwi.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Mar 2010 16:46:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m3tys0tbhk.fsf@intrepid.localdomain>
References: <m3tys0tbhk.fsf@intrepid.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 28 Mar 2010 16:45:59 -0700
Message-ID: <43e72e891003281645m1da47a1en882df4432733977d@mail.gmail.com>
Subject: Re: CRDA and ath5k with no country code in EEPROM
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 28, 2010 at 1:52 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> Hi,
>
> I'm not sure I get it right:
> I have an ath5k card without a country code in EEPROM. I think such card
> is supposed to not force any additional restrictions, am I wrong?
> The problem is "no country code" is effectively equal to US, i.e. it's
> forcing additional US restrictions no matter what the actual regdomain
> is.
>
> Linux 2.6.33.
>
> ath5k 0000:00:0d.0: registered as 'phy0'
> ath: EEPROM regdomain: 0x0

I've documented this specific case here:

http://wireless.kernel.org/en/users/Drivers/ath/#The_0x0_regulatory_domain

  Luis
