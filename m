Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35205 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932342AbcK1PTc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 10:19:32 -0500
Received: by mail-oi0-f43.google.com with SMTP id b126so152991821oia.2
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2016 07:19:31 -0800 (PST)
MIME-Version: 1.0
From: bruce m beach <brucembeach@gmail.com>
Date: Mon, 28 Nov 2016 07:19:30 -0800
Message-ID: <CAArymCm2O1wOKAU0Uj-jDvRttNiyvcEWOQ+hG79QDpTD5_k8xA@mail.gmail.com> (sfid-20161128_161934_738811_38ADA7E2)
Subject: limiting times ath9k_htc devices are loaded
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

  When I plug in a ath9k_htc device, with a loaded driver, the driver
attemps to attach itself to the device and load firmware etc. ( of
course ). Does anyone know how I can tell the driver ( or kernel ) to
do this process only once, and ignore additional insertions of
ath9k_htc devices ?

Bruce
