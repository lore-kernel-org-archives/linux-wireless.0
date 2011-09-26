Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2873 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab1IZTHc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 15:07:32 -0400
Message-ID: <4E80CD64.8070103@broadcom.com> (sfid-20110926_210736_919051_92BA958B)
Date: Mon, 26 Sep 2011 12:07:16 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "gregkh@suse.de" <gregkh@suse.de>
cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 08/20] staging: brcm80211: cleanup structure fields
 used for scanning
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
 <1316830148-28661-9-git-send-email-frankyl@broadcom.com>
In-Reply-To: <1316830148-28661-9-git-send-email-frankyl@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/2011 07:08 PM, Franky Lin wrote:
> From: Arend van Spriel<arend@broadcom.com>
>
> In the structure brcmf_cfg80211_priv two fields were defined
> in which one was allocated and a second was referenced back to
> the first for no obvious reasons. Also the name was misleading
> giving the impression that the driver was maintaining a list of
> BSS entries like cfg80211 does.
>
> Reported-by: Johannes Berg<johannes@sipsolutions.net>
> Reviewed-by: Franky (Zhenhui) Lin<frankyl@broadcom.com>
> Reviewed-by: Roland Vossen<rvossen@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts<pieterpg@broadcom.com>
> Signed-off-by: Franky Lin<frankyl@broadcom.com>

Hi Greg,

Please drop this one. The rest of this series should still be fine 
without this one. We found out this patch introduced a bug to fullmac. 
Will fix it and resend in the future.

Thanks,
Franky

