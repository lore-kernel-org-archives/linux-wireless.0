Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:63247 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932773AbeAKREq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jan 2018 12:04:46 -0500
Subject: Re: [PATCH v3 0/6] fixes to remove enum typedefs
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>
References: <1515679939-13202-1-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <2373902b-0a48-479a-2799-d8292a94c06b@microchip.com> (sfid-20180111_180450_234043_B5A54BB7)
Date: Thu, 11 Jan 2018 19:04:43 +0200
MIME-Version: 1.0
In-Reply-To: <1515679939-13202-1-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ajay,

Just a little note for your future patches: all changes history would
be good to be kept here, something like this:

changes in v3: this, this and this

changes in v2: this and this

Thanks,
Claudiu

On 11.01.2018 16:12, Ajay Singh wrote:
> Changes since v2: Removed v2 patch number 3,4,5 , where were handling
> 	different changes under same subject line.
> 	As those changes were independent, will work on those items and
> 	send as separate patch later.
> 	
> 
> Ajay Singh (6):
>   staging: wilc1000: removed typedef from enum BSSTYPE_T
>   staging: wilc1000: remove unnecessary typedef enum G_OPERATING_MODE_T
>   staging: wilc1000: removed enums typedef for BEACON_IE & TX_RATE_T
>   staging: wilc1000: removed enum typedef CHIP_PS_STATE_T
>   staging: wilc1000: removed enum typedef BUS_ACQUIRE_T
>   staging: wilc1000: removed enum typedef BUS_RELEASE_T
> 
>  drivers/staging/wilc1000/host_interface.c |  2 +-
>  drivers/staging/wilc1000/wilc_wlan.c      |  6 +++---
>  drivers/staging/wilc1000/wilc_wlan_if.h   | 28 ++++++++++++++--------------
>  3 files changed, 18 insertions(+), 18 deletions(-)
> 
