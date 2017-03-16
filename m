Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60745 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751487AbdCPJhR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 05:37:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath6kl: Remove old 802.11a-only channels
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <CAPXt_dabk8KNL0HTHZJfoHT+93ZS+3R31tVEPb4zpKJWE65cMw@mail.gmail.com>
References: <CAPXt_dabk8KNL0HTHZJfoHT+93ZS+3R31tVEPb4zpKJWE65cMw@mail.gmail.com>
To: Rostyslav Khudolii <rkhudolii@airtame.com>
CC: <ath6kl@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Attila Sukosd" <attila@airtame.com>
Message-ID: <02e3d7706b82480d86fb2fcff76969b3@euamsexm01a.eu.qualcomm.com> (sfid-20170316_103720_780831_2D33B846)
Date: Thu, 16 Mar 2017 10:36:53 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rostyslav Khudolii <rkhudolii@airtame.com> wrote:
> Channels 34/38/42/46 can only be used for compatibility with
> old devices sold in Japan. Modern products, such as AR6003/AR6004
> don't support these channels.
> Keeping them in the upstream is error prone and requires full
> network stack support.
> A custom patch should be used in case such compatibility is required.
> 
> Signed-off-by: Rostyslav Khudolii <rkhudolii@airtame.com>
> Cc: Attila Sukosd <attila@airtame.com>

For some reason the patch didn't apply to ath.git, I had manually recreate it.
Please review carefully that the patch is correct now:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=cd63adf640e39c2ba013cba91b29700f3f593b9c

Also I added your description of the bug to the commit log.

-- 
https://patchwork.kernel.org/patch/9615199/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
