Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:45108 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752636AbeB0KQO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 05:16:14 -0500
Received: by mail-io0-f177.google.com with SMTP id m22so20607726iob.12
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2018 02:16:14 -0800 (PST)
MIME-Version: 1.0
From: Harsha Rao <harshrao464@gmail.com>
Date: Tue, 27 Feb 2018 15:46:13 +0530
Message-ID: <CAPcv9S3wyPd5jD1PZWtDf-mRicmzRmz00qh5Jbov_N_egBAEZg@mail.gmail.com> (sfid-20180227_111621_509785_B1F818D0)
Subject: Support on vendor id and device id
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks,
I am developing a new wifi driver for our sdio based wifi device.

I see that SDIO_VENDOR_ID and SDIO_DEVICE_ID for our device (We had
bought the SDIO IP from 3rd party)  is already  been used by some
other vendor and its already into staging .

Please suggest me how can I move forward to submit the driver for staging.

Is there a way to reconfigure the values in the SDIO host for
different value or does Linux allow two drivers with same values to
survive mutual exclusively

-
Harsha
