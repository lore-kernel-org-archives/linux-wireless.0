Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:61832 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab0JHQpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 12:45:49 -0400
Received: by pxi15 with SMTP id 15so214174pxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Oct 2010 09:45:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <SNT111-W21A1F92DC5DADE5968C8CCFB500@phx.gbl>
References: <SNT111-W333C4BA6050D535151071FFB690@phx.gbl> <SNT111-W2989DC6A52022428756E6FB500@phx.gbl>
 <20101008111221.5425.qmail@stuge.se> <AANLkTimAfH8ChkjwFB7e2kMbJyxaZQZMSxTcThva=jgN@mail.gmail.com>
 <SNT111-W21A1F92DC5DADE5968C8CCFB500@phx.gbl>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 8 Oct 2010 09:45:28 -0700
Message-ID: <AANLkTikc9+bULkH2Fv7mEtBjbjatMW8XOXjXZVuA81hD@mail.gmail.com>
Subject: Re: [ath9k-devel] trying to set tx power (using txpower option)
To: At Santos <atsan@hotmail.co.uk>
Cc: ath9k <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 8, 2010 at 9:23 AM, At Santos <atsan@hotmail.co.uk> wrote:
>
>
>> Actually, you can set tx power with iw now:
>>
>> http://wireless.kernel.org/en/users/Documentation/iw#Setting_TX_power
>>
>> I will note you will need 2.6.36, or compat-wireless-2.6.36, otherwise
>> you have to use iwconfig, setting txpower with nl80211 was only added
>> as of 2.6.36.
>>
>> Luis
>
> Thanks for the response.
>
> I'm running with compat-wireless-2.6.36-rc3-1 and I'm finding that iw
> doesn't work with fixed or limit:
>
> $ sudo iw wlan0 set txpower fixed 20
> command failed: Operation not supported (-95)
>
> So it seems it's broken at the moment.
> To where should I report the bug?

You can use bugzilla.kernel.org please report it there and we can fix
it. I can't look into right now though as I'm looking into another
issue. If someone else has cycles it would be appreciated.

  Luis
