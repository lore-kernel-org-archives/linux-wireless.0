Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f176.google.com ([209.85.210.176]:35152 "EHLO
        mail-wj0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751340AbcLEU0r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 15:26:47 -0500
Received: by mail-wj0-f176.google.com with SMTP id v7so300679825wjy.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2016 12:26:47 -0800 (PST)
MIME-Version: 1.0
From: Hany Assasa <hany.assasa@gmail.com>
Date: Mon, 5 Dec 2016 21:26:45 +0100
Message-ID: <CACwg7oC6_i+tY6jK7FUhT-BRqrNrdE642WXPWCOhcicqkACMmw@mail.gmail.com> (sfid-20161205_212651_377121_6EA49F55)
Subject: wil6210: Low level RF sector API + Wrong Rx Sector Information
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Maya and Lior,

1. Regarding the patch for adding new APIs for low level RF sector in
wil6210 driver, is it only intended for special firmware or it can
support the available firmware which comes with the ACER Laptop and
TP-Link AD7200 Router?

2. In the reported debug information in the beamforming file (bf), the
reported Rx sector is always constant (96) and above the allowed range
in the standard. is it because the sector sweep is limited to transmit
sector training?

Thanks.

Best Regards,
Hany Assasa
