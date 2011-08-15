Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58394 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab1HOOk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 10:40:59 -0400
Received: by gxk21 with SMTP id 21so3191812gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Aug 2011 07:40:58 -0700 (PDT)
Message-ID: <4E492FF7.3070000@lwfinger.net> (sfid-20110815_164102_526457_56E656A7)
Date: Mon, 15 Aug 2011 09:40:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Wolfgang.Hotz@BNetzA.de
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Driver issue
References: <92A7AA957AF9C441B3A77A2265F81C5B7DBB09@ITMAIN01E011.MAIN01.INTERN.ADNS>
In-Reply-To: <92A7AA957AF9C441B3A77A2265F81C5B7DBB09@ITMAIN01E011.MAIN01.INTERN.ADNS>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/15/2011 07:47 AM, Wolfgang.Hotz@BNetzA.de wrote:
> Dear Larry,
>
> I installed the latest driver ( Realtek 8192C/8188C, Version
> 0003.0620.2)  for my realtek wireless in the Ubuntu Kernel 2.6.38-8. I
> had no system freeze since then, which was excellent. Now Ubuntu uptated
> the Kernel to 2.6.38-10. I recompiled the same driver into this Kernel
> and now I get systemfreezes again like with the old driver in 2.6.38-8.
> Will there be an updated driver?
>
> Kind regards and thanks for your awsome work!

Please implement compat-wireless to get the latest driver for the 
RTL8192CE/RTL8188CE, or switch to kernel 3.9.

Larry
