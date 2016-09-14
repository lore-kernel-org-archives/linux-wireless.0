Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17812 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755879AbcINMYq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 08:24:46 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: handle testmode events for 10.2 based firmware
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160603153328.11947-1-rmanohar@qti.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>,
        <rmanohar@codeaurora.org>
Message-ID: <20496dae439740198669bc2de651ca50@euamsexm01a.eu.qualcomm.com> (sfid-20160914_142450_914270_59079B0D)
Date: Wed, 14 Sep 2016 14:24:39 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> Currently testmode events for 10.x firmware are processed from
> 10.1 wmi event processing. In order to remove 10.1 firmware support,
> testmode events should be handled from 10.2 event processing.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

This is an old patch, but we already have this functionality in
ath10k_wmi_10_2_op_rx(). So I'll drop this patch.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9153395/
