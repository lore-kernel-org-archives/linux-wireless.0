Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50328 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab1GAUBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 16:01:04 -0400
Received: by yxi11 with SMTP id 11so1080375yxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jul 2011 13:01:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110701152949.wktyhphv6884ww4s-cebfxv@webmail.spamcop.net>
References: <BANLkTimsGJo61eLp3NrVtDkh0m3CN3zDxw@mail.gmail.com>
	<4E0B8A61.8090600@upr.edu>
	<4E0B8E35.8080203@gnu.org>
	<BANLkTikEqPt1NkPr99Cfp_Rfp63z3s669Q@mail.gmail.com>
	<20110701152949.wktyhphv6884ww4s-cebfxv@webmail.spamcop.net>
Date: Fri, 1 Jul 2011 22:01:03 +0200
Message-ID: <BANLkTimqe-npBQ2hsaYMVPBkE2pgQmgA+A@mail.gmail.com> (sfid-20110701_220108_571034_F75036E1)
Subject: Re: Compile error in carl9170 on Debian Squeeze
From: Alex <alex9434@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Omar Abraham <omar.abraham@upr.edu>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Great, thanks a lot. Worked now!!!

On Fri, Jul 1, 2011 at 9:29 PM, Pavel Roskin <proski@gnu.org> wrote:
> Quoting Alex <alex9434@gmail.com>:
>
>> Pavel, Omar and all,
>>
>> thank you very much for your support. However, I still get the error
>> message:
>>
>>                 from <command-line>:0:
>> /usr/src/compat-wireless-2011-06-30/include/linux/compat-2.6.34.h:23:
>> error: redefinition of 'netdev_name'
>
> It takes some time to propagate patches.  The patch appeared in
> compat-wireless-2011-07-01, which is available now.
>
>> BTW: One more question: There seems to be a module "carl9170" in the
>> 2.6.39.2 kernel. Does this replace compat-wireless? Do I only need
>> this module to get the wlan in monitor mode? (please excuse my
>> question, I am really new to this...)
>
> You can try it.  The point of compat-wireless is to make the current
> wireless drivers available for older kernels.  If you kernel is not so old,
> you make have the functionality you need in your kernel already.  But if you
> want to use the older Debian kernel, compat-wireless is the only option.
>
> --
> Regards,
> Pavel Roskin
>
