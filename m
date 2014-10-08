Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55644 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbaJHJ0P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 05:26:15 -0400
Message-ID: <543503A6.2000408@intel.com> (sfid-20141008_112619_037972_8C2FE7E2)
Date: Wed, 08 Oct 2014 11:28:06 +0200
From: Loic Poulain <loic.poulain@intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: heikki.krogerus@linux.intel.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] net: rfkill: gpio: Configurable GPIO idx
References: <1412757280-31367-1-git-send-email-loic.poulain@intel.com> <1412758401.1811.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1412758401.1811.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

acpi_device_id driver_data field is defined as a kernel_ulong_t in 
mod_devicetable.h.

Regards,
Loic

On 08/10/2014 10:53, Johannes Berg wrote:
> On Wed, 2014-10-08 at 10:34 +0200, Loic Poulain wrote:
>
>> +	{ "BCM2E1A", (kernel_ulong_t)&acpi_default_bluetooth },
> Shouldn't that be uintptr_t?
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Intel Open Source Technology Center
http://oss.intel.com/

