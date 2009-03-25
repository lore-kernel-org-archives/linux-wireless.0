Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:49328 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391AbZCYHKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 03:10:07 -0400
Received: by wf-out-1314.google.com with SMTP id 29so3891805wff.4
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 00:10:05 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 25 Mar 2009 00:09:50 -0700
Message-ID: <43e72e890903250009hbe7bcfal546dddf731820b8e@mail.gmail.com> (sfid-20090325_081011_326192_34BC958A)
Subject: Re: [renamed] Debian crda?
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kel Modderman <kel@otaku42.de>,
	Kyle McMartin <kyle@mcmartin.ca>,
	Debian Devel <debian-devel@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 11:44 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> "Luis R. Rodriguez" <mcgrof@gmail.com> writes:
>
>> As a lot of you know we have a new regulatory implementation for Linux
>> wireless now [1]. We have kept the old regulatory implementation
>> through a Kconfig option, CONFIG_WIRELESS_OLD_REGULATORY.
>> Distributions are slowly converging to start setting this to "N" -- as
>> of 2.6.28. Distributions are also now shipping wireless-regdb [2] and
>> CRDA [3].
>
> Just of curiosity, what's happening with crda in debian? I still don't
> see them in debian unstable.
>
> I just found iw version 0.9.9-nogit in unstable, though. So things are
> going forward.

Last time I poked them it seemed it was not easy to figure out how to
deal with, if at all, the optional but recommended RSA signature stuff
[1] with the DFSG.

[1] http://wireless.kernel.org/en/developers/Regulatory#RSADigitalSignature

  Luis
