Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59060 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1LNVSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 16:18:45 -0500
Received: by eaaj10 with SMTP id j10so1256207eaa.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 13:18:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323851355.3380.5.camel@jlt3.sipsolutions.net>
References: <1323851355.3380.5.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Wed, 14 Dec 2011 23:18:28 +0200
Message-ID: <CA+XVXfdpyUKEAM-Pk8Dd=kJ5y9z8_hbHciKx9XppAH2M_Znmvg@mail.gmail.com> (sfid-20111214_221849_910353_8A8E5799)
Subject: Re: [PATCH] nl80211: add TDLS peer flag to policy
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 14, 2011 at 10:29, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> This was evidently missed in the TDLS patch (07ba55d7).
>
> Cc: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/nl80211.c |    1 +
>  1 file changed, 1 insertion(+)

Thanks

Arik
