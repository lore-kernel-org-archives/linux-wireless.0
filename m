Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:27570 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYEPAuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 20:50:19 -0400
Received: by an-out-0708.google.com with SMTP id d40so153309and.103
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2008 17:50:18 -0700 (PDT)
Message-ID: <40f31dec0805151750w7d1c8654jae7bc20064cbb16e@mail.gmail.com> (sfid-20080516_025026_761941_1AC16833)
Date: Fri, 16 May 2008 03:50:18 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Zack Weinberg" <zackw@panix.com>
Subject: Re: Getting ath5k driver working with Thinkpad T61 [168c:1014]
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <eb97335b0805141024w6afa864j860b312b072faa8a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <eb97335b0805141024w6afa864j860b312b072faa8a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> ath_info does not work:
> # ath_info df3f0000
> Unable to read EEPROM Magic value!
>

Hm, have you tried latest ath_info from
http://madwifi.org/browser/ath_info/trunk

This one looks interesting, plz use ndiswrapper for your card and use
mmiotrace to see
what windows driver does in your situation that makes the card work.

Follow the link Bob gave you, it has instructions for 2.6.25. Remember
if you have enabled
4K stacks on your kernel configuration to disable it otherwise
ndiswrapper won't work.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
