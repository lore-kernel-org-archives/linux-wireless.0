Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40010 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbbIZS2q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2015 14:28:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: egrumbach@gmail.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next 2015-09-21
References: <1442868938.27148.361.camel@coelho.fi>
Date: Sat, 26 Sep 2015 21:28:39 +0300
In-Reply-To: <1442868938.27148.361.camel@coelho.fi> (Luca Coelho's message of
	"Mon, 21 Sep 2015 23:55:38 +0300")
Message-ID: <87si61c9wo.fsf@kamboji.qca.qualcomm.com> (sfid-20150926_202912_259988_2E804E8B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> This is our first pull request for 4.4.  This is also my first pull
> -request for iwlwifi, so bear with me and let me know if there are any
> issues.  And please don't come here to beat me up physically if I did
> something wrong (it's scary to send pull requests to maintainers that
> are just a couple of hours drive away). :)

Hehe, don't worry everything was perfect :)

> The following changes since commit 5865f3658ba37c54e346b0fdee08a1c7a152681b:
>
>   iwlwifi: mvm: bump firmware API to 17 (2015-08-23 12:54:16 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2015-09-21
>
> for you to fetch changes up to 7c014e35a018187462f2cd6c85259e080663ba2d:
>
>   iwlwifi: mvm: add debug print for d0i3 exit indication (2015-09-21 18:08:46 +0300)
>
> ----------------------------------------------------------------
> * some debugfs improvements;
> * fix signedness in beacon statistics;
> * deinline some functions to reduce size when device tracing is enabled;
> * filter beacons out in AP mode when no stations are associated;
> * deprecate firmwares version -12;
> * fix a runtime PM vs. legacy suspend race;
> * one-liner fix for a ToF bug;
> * clean-ups in the rx code;
> * small debugging improvement;
> * fix WoWLAN with new firmware versions;
>
> ----------------------------------------------------------------

Thanks, pulled.

-- 
Kalle Valo
