Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45734 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1EFX1p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 19:27:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110506232814.3ca7b943@lxorguk.ukuu.org.uk>
References: <1304719780-27347-1-git-send-email-lrodriguez@atheros.com>
 <1304719780-27347-3-git-send-email-lrodriguez@atheros.com> <20110506232814.3ca7b943@lxorguk.ukuu.org.uk>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 6 May 2011 16:27:25 -0700
Message-ID: <BANLkTik5g3r_aqbp=zTawEtgzYCGwCZ_Xw@mail.gmail.com> (sfid-20110507_012804_370471_FABB005F)
Subject: Re: [RFC 2/2] x86: add Atheros ar1520 platform support for mrst
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
	hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, allen.kao@atheros.com,
	roman.gezikov@atheros.com, joonas.viskari@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 6, 2011 at 3:28 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 6 May 2011 15:09:40 -0700
> "Luis R. Rodriguez" <lrodriguez@atheros.com> wrote:
>
>> From: Allen Kao <allen.kao@atheros.com>
>>
>> This adds platform driver support for Atheros ar1520 GPS device
>> on the Intel Moorestown Low Power Intel Architecture (LPIA) based
>> Moblin Internet Device (MID) platform.
>
> NAK - for the same reasons as before, and the same NAK you already got on
> the other list.
>
> No open user space or sufficient API docs to make use of the kernel
> driver and write your own = not a candidate for submission. Same for the
> 3D graphics on that platform.

I was under the impression an open userspace app was going to be
provided.... I'll check with the team.

 Luis
