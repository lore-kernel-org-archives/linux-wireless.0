Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:52639 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaBHJm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Feb 2014 04:42:29 -0500
Message-ID: <52F5FC02.8050508@broadcom.com> (sfid-20140208_104235_514359_C8CEB8F3)
Date: Sat, 8 Feb 2014 10:42:26 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
CC: <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 2/8] iwlwifi: mvm: disable scheduled scan
References: <52EFFCE8.6070505@gmail.com> <1391459962-7381-2-git-send-email-egrumbach@gmail.com>
In-Reply-To: <1391459962-7381-2-git-send-email-egrumbach@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/03/14 21:39, Emmanuel Grumbach wrote:
> From: Johannes Berg<johannes.berg@intel.com>
>
> The iwlwifi scheduled scan implementation doesn't adhere to the
> userspace API correctly - the API assumes that any new incoming
> 'incompatible' request (like scan or remain-on-channel for this
> driver) will just cancel the scheduled scan. Instead our driver
> relies on userspace cancelling it, thus breaking existing wpa_s
> versions.

I think iwlwifi is not alone in this. At least I have to put a new task 
on my todo list ;-)

Regards,
Arend

