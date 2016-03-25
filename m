Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:33403 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbcCYNvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2016 09:51:50 -0400
Received: by mail-ob0-f178.google.com with SMTP id xj3so59139567obb.0
        for <linux-wireless@vger.kernel.org>; Fri, 25 Mar 2016 06:51:49 -0700 (PDT)
Date: Fri, 25 Mar 2016 08:51:47 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Thanh_Nguyen@Dell.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb: Update regulatory rules for Russia (RU) on
 5735-5835 MHz band
Message-ID: <20160325135147.GA27324@ubuntu-xps13> (sfid-20160325_145153_662943_8F1003F6)
References: <b7a3a22077814e7da4e94a61e59c585d@ausx13mpc122.AMER.DELL.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <b7a3a22077814e7da4e94a61e59c585d@ausx13mpc122.AMER.DELL.COM>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 24, 2016 at 09:19:46PM +0000, Thanh_Nguyen@Dell.com wrote:
> Dear Seth,
> Currently the db.txt has following setting for Russia:
> 
> country RU: DFS-ETSI
>                 (2402 - 2482 @ 40), (20)
>                 (5170 - 5250 @ 80), (20), AUTO-BW
>                 (5250 - 5330 @ 80), (20), DFS, AUTO-BW
>                 (5650 - 5730 @ 80), (30), DFS
>                 (5735 - 5835 @ 80), (30)
>                 # 60 GHz band channels 1-4, ref: Changes to NLA 124_Order №129_22042015.pdf
>                 (57000 - 66000 @ 2160), (40)
> 
> Dell’s understanding is 5735-5835 MHz band is still not allowed in Russia. Dell would like to submit a request for the wireless-regdb to investigate and update the setting for Russia RU in the db.txt file.

I wasn't able to track down any official documentation of Russia's
regulations, but a few unofficial sources showed that range as being
allowed. What source(s) are you using to determine that it is not?

Feel free to send a patch if you think this should be changed, or I can
make one if you're not comfortable doing so. It would be helpful to have
a link to support the change though.

Thanks,
Seth
