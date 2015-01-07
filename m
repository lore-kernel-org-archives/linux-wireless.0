Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:43211 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbbAGR5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 12:57:13 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/11 V2] rtlwifi: A set of patches that simplify the drivers
References: <1420559892-12384-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Wed, 07 Jan 2015 19:57:07 +0200
In-Reply-To: <1420559892-12384-1-git-send-email-Larry.Finger@lwfinger.net>
	(Larry Finger's message of "Tue, 6 Jan 2015 09:58:01 -0600")
Message-ID: <87y4pepj7w.fsf@kamboji.qca.qualcomm.com> (sfid-20150107_185723_524751_CA01D4D2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> Happy New Year.
>
> This set of patches, which are intended for the 3.20 stream, are intended to
> simplify the drivers. In particular, each of them has a separate routine that
> initilizes the dynamic power manipulation variables. Ten of these patches convert
> the drivers to use a common copy of this code. The other patch updates the
> parameter descriptions of rtl8723be to clarify usage.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> V2 - only patch 02/11 is changed to fix the problem noted by Sergei Shylyov
>      <sergei.shtylyov@cogentembedded.com> concerning a line that was dropped.
>
> Larry Finger (11):
>   rtlwifi: Unify variable naming for all drivers
>   rtlwifi: rtl8723be: Improve modinfo output
>   rtlwifi: Create new routine to initialize the DM tables
>   rtlwifi: rtl8188ee: Convert driver to use the common DM table init
>     routine
>   rtlwifi: rtl8192c-common: Convert driver to use common DM table
>     initialization
>   rtlwifi: rtl8192de: Convert driver to use common DM table
>     initialization
>   rtlwifi: rtl8192ee: Convert driver to use common DM table
>     initialization
>   rtlwifi: rtl8723ae: Convert driver to use common DM table
>     initialization
>   rtlwifi: rtl8723be: Convert driver to use common DM table
>     initialization
>   rtlwifi: rtl8821ae: Convert driver to use common DM table
>     initialization
>   rtlwifi: Move macro definitions to core

Thanks, all 11 applied to wireless-drivers-next.git.

-- 
Kalle Valo
