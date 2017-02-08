Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49126 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751439AbdBHPGb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 10:06:31 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: select WANT_DEV_COREDUMP
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170207222933.12701-1-johannes@sipsolutions.net>
References: <20170207222933.12701-1-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Message-ID: <c34b8f1afabe4ae3ad36642565a1f212@eusanexr01a.eu.qualcomm.com> (sfid-20170208_160634_276809_14E5526A)
Date: Wed, 8 Feb 2017 07:05:06 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This is necessary so that - if ath10k is the only driver using
> dev_coredump*() - the functionality is built into the kernel.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Patch applied to ath-next branch of ath.git, thanks.

5524ddd4c1f1 ath10k: select WANT_DEV_COREDUMP

-- 
https://patchwork.kernel.org/patch/9561349/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
