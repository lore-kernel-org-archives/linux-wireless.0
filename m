Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1653 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab1FCRuy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 13:50:54 -0400
Message-ID: <4DE91EF8.6010404@broadcom.com> (sfid-20110603_195058_131782_877B3F8D)
Date: Fri, 3 Jun 2011 10:50:48 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Julian Calaby" <julian.calaby@gmail.com>
cc: "Roland Vossen" <rvossen@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 50/83] staging: brcm80211: absorb bcmcdc.h into
 dhd_cdc.c
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <1306928768-7501-50-git-send-email-rvossen@broadcom.com>
 <BANLkTikgGUmRmdXmjgs-cViFr_JzTCVpgA@mail.gmail.com>
In-Reply-To: <BANLkTikgGUmRmdXmjgs-cViFr_JzTCVpgA@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/1/2011 4:37:53 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> On Wed, Jun 1, 2011 at 21:45, Roland Vossen<rvossen@broadcom.com>  wrote:
>> From: Franky Lin<frankyl@broadcom.com>
>>
>> Merge bcmcdc.h into dhd_cdc.c in fullmac as it's only used by
>> dhd_cdc.c
>>
>> Signed-off-by: Franky Lin<frankyl@broadcom.com>
>> Reviewed-by: Roland Vossen<rvossen@broadcom.com>
>> Reviewed-by: Arend van Spriel<arend@broadcom.com>
>
> Again, you might want to mention the typedef elimination in the description.
>
> Thanks,
>

Hi Julian,

Sorry for the late response. I removed the typedef to fix the checkpatch 
warning. I will keep this in mind for the future patches.

Thanks for remarks.

Franky

