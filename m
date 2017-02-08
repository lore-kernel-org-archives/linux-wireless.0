Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13333 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752515AbdBHPIH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 10:08:07 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wil6210: include moduleparam.h
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170207143328.22529-1-johannes@sipsolutions.net>
References: <20170207143328.22529-1-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Message-ID: <441c84ea195949cd95ed2c28bb43572c@eusanexr01a.eu.qualcomm.com> (sfid-20170208_160908_236879_D9C4EBF1)
Date: Wed, 8 Feb 2017 07:01:52 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This now declares a module parameter, so include the necessary
> header file for that.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Patch applied to ath-next branch of ath.git, thanks.

949c2d009675 wil6210: include moduleparam.h

-- 
https://patchwork.kernel.org/patch/9560281/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
