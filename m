Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40146 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750723AbdGYFlL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 01:41:11 -0400
Message-ID: <1500961268.20057.40.camel@coelho.fi> (sfid-20170725_074116_537415_ECCF3104)
From: Luca Coelho <luca@coelho.fi>
To: =?UTF-8?Q?=E9=BE=9A=E6=81=92?= <18278134232@139.com>,
        linux-wireless@vger.kernel.org
Cc: linuxwifi@intel.com
Date: Tue, 25 Jul 2017 08:41:08 +0300
In-Reply-To: <efb38427-f17d-2761-4883-baea2084a268@139.com>
References: <efb38427-f17d-2761-4883-baea2084a268@139.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: wireless drives for intel 3165
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Hi,

With kernel v4.9, you must use the iwlwifi-7265D-22.ucode.  The driver
supports up to -26, but we didn't release firmwares 23 to 26 publicly.

The error messages you're seeing are harmless, because they seem to stop
 -23, which probably means -22 was found, loaded and everything should
work fine. :)

HTH.

--
Cheers,
Luca.


On Tue, 2017-07-25 at 12:18 +0800, 龚恒 wrote:
> hello,my computer'system is deepin15.4.1,the kernels is 4.9.0,my 
> computer turn on failed to load iwlwifi-7265D-26.ucode , failed to load 
> iwlwifi-7265D-25.ucode ,failed to load iwlwifi-7265D-24.ucode and failed 
> to load iwlwifi-7265D-23.ucode .
> I don't find firmware for inter 3165 with the most leastest,I need your 
> help,can you help me find the  firmware for iwlwifi-7265D-26.ucode , 
> failed to load iwlwifi-7265D-25.ucode ,failed to load 
> iwlwifi-7265D-24.ucode and failed to load iwlwifi-7265D-23.ucode and 
> send my email,thank you
> 
> 
