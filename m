Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29449 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbcIIMN1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 08:13:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath6kl: enable firmware crash dumps on the AR6004
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1470257023-6747-1-git-send-email-dan.kephart@lairdtech.com>
To: <engineering@keppy.com>
CC: <ath6kl@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <463d416b29d941dfbad0edaa6ec850a1@euamsexm01a.eu.qualcomm.com> (sfid-20160909_141339_405964_DCC25F83)
Date: Fri, 9 Sep 2016 14:13:20 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

engineering@keppy.com wrote:
> From: Dan Kephart <dan.kephart@lairdtech.com>
> 
> The firmware crash dumps on the 6004 are the same as the 6003. Remove the
> statement guarding it from dumping on the 6004.  Renamed the
> REG_DUMP_COUNT_AR6003 to reflect support on both chips.
> 
> Signed-off-by: Dan Kephart <dan.kephart@lairdtech.com>
> Reviewed-by: Steve deRosier <steve.derosier@lairdtech.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

f3fa63144482 ath6kl: enable firmware crash dumps on the AR6004

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9262289/
