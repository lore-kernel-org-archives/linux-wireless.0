Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34796 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab1ECGN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 02:13:56 -0400
Received: by yxs7 with SMTP id 7so1981305yxs.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2011 23:13:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DBF1967.9010604@candelatech.com>
References: <4DBF1967.9010604@candelatech.com>
Date: Tue, 3 May 2011 14:13:50 +0800
Message-ID: <BANLkTimYks_+QRUNURtbRy+S941fL04HRQ@mail.gmail.com> (sfid-20110503_081400_003846_9FAFD08E)
Subject: Re: Looking for 3x3 Atheros NICs using ath9k driver.
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The AR9160/SR71-A should be supported by ath9k. They're just 2x2
stream devices using 3 radios.

What do you mean by "not even supported" ?

If the SR71-A isn't working for you then please email the ath9k list
and I'll take a look. I have a bunch of SR71-A hardware here to tinker
with.




Adrian

On 3 May 2011 04:51, Ben Greear <greearb@candelatech.com> wrote:
> Hello!
>
> We are trying to find some Atheros NICs that support 3x3
> MIMO, but we are having a hard time.
>
> We mistakenly ordered some Ubiquity SR71-A NICs, but those aren't
> even supported by ath9k it seems (visible chipset is AR9160-AC1E).
> There are some other SR71 NICs that *do* work (AR9160-BC1A), but
> hard to order that specific version.
>
> Sparklan seems to make one based on AR9380, but they are not
> in stock any place we could find.
>
> Anyone know of any others that are available to the public
> in small quantities?
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
