Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:38478 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbbCYJIA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2015 05:08:00 -0400
Received: by igbqf9 with SMTP id qf9so19782991igb.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2015 02:07:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1427245230396.59674@mail.polimi.it>
References: <1427048376242.67051@mail.polimi.it>
	<CAMowtuMgAPsgAKuwSibjAzhDbqEdZGatikCiKks6f3w=4oth+Q@mail.gmail.com>
	<1427059313289.43792@mail.polimi.it>
	<550FE50F.10303@broadcom.com>
	<1427245230396.59674@mail.polimi.it>
Date: Wed, 25 Mar 2015 10:07:59 +0100
Message-ID: <CACna6ryn2byWm+aAd6JykQRid08QjGJ-JXYRAudcCxHgoFr36g@mail.gmail.com> (sfid-20150325_100954_843268_EB8C63F5)
Subject: Re: informations about Linux wifi driver's architecture today
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Stefano Cappa <stefano.cappa@mail.polimi.it>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 March 2015 at 02:00, Stefano Cappa <stefano.cappa@mail.polimi.it> wrote:
> Thank you very much Arend, in particular for the documentation.
>
> If i understand correctly, the levels are:
> userspace
> nl802111
> cfg80211
> firmware

There's also brcmfmac internal code translating cfg80211 into firmware
messages, but you probably know that.


> No mac80211 because is a fullmac.
> Correct?

Yes.

-- 
Rafał
