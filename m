Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12381 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbcHSKNI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 06:13:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/8] wil6210: align to latest auto generated wmi.h
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1470138132-18071-2-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Message-ID: <729c8dfb737549dbbb6ce900b3391fff@euamsexm01a.eu.qualcomm.com> (sfid-20160819_121312_028399_6E72E259)
Date: Fri, 19 Aug 2016 12:12:59 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:
> Align to latest version of the auto generated wmi file
> describing the interface with FW.
> 
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

Thanks, 8 patches applied to ath-next branch of ath.git:

0163b0319900 wil6210: align to latest auto generated wmi.h
f1b7764f8626 wil6210: fix HALP handling in case of HALP vote time-out
74b6ac586d9c wil6210: support rx key setting for all TIDs
ef86f249fa49 wil6210: change HALP logging category to IRQ
d35c2b6f8ffa wil6210: fix stop p2p device handling
b0c0e688e523 wil6210: Fix driver down flow
dc90506f1458 wil6210: prevent usage of incorrect TX hwtail
2690c4c0e83b wil6210: fix wiphy registration sequence

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9259343/
