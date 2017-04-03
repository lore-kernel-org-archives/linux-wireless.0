Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:33767 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751920AbdDCJCn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 05:02:43 -0400
Received: by mail-lf0-f45.google.com with SMTP id h125so68424185lfe.0
        for <linux-wireless@vger.kernel.org>; Mon, 03 Apr 2017 02:02:43 -0700 (PDT)
MIME-Version: 1.0
From: Adrien Decostre <ad.decostre@gmail.com>
Date: Mon, 3 Apr 2017 11:02:01 +0200
Message-ID: <CAOtFK_Xr50=9h+McOY1sg41=jPry5n80u-+M=S4tGSpme8Qjhg@mail.gmail.com> (sfid-20170403_110247_353857_33A60A09)
Subject: Question about ath9k compliancy with upcoming EN 301 893 v2.0.7
To: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
        kvalo@adurom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

ETSI is publishing in the coming months an update of the EN 301 893
standard with major changes on the adaptivity and receiver blocking
tests behavior (https://www.nts.com/ntsblog/upcoming-changes-for-wireless-equipment-in-the-5-ghz-band-en-301-893/).
The adaptivity test requirements will now require the 802.11 link
being stopped in the case of some particular OFDM interference signal.
I was looking on the mailing list archive for information about the
modifications required in the ath9k in order to keep compliancy but I
did not found any relevant discussion. Would someone know if the ath9k
driver can be configured to break connection at the detection of high
enough OFDM signal not compliant with the 802.11 standard?

Many thanks in advance for any help

Best regards
