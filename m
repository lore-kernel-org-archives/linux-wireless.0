Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:33168 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1430898AbdDYNy4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 09:54:56 -0400
Received: by mail-wr0-f170.google.com with SMTP id w50so86024925wrc.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Apr 2017 06:54:55 -0700 (PDT)
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Adam Casson <adam.casson@inscopemedical.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: WPA authorization with RTL8723DS
Message-ID: <3edb18bd-636c-4da1-ad17-fb817320b3e6@gmail.com> (sfid-20170425_155508_676696_84044C05)
Date: Tue, 25 Apr 2017 15:54:52 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:

> I was not aware that a 8723D chip had been released. If there is a PCI version 
> (8723DE), then there is probably not a Linux driver for it.
It's an "802.11bgn SDIO WLAN with Bluetooth 4.2 Single-Chip Controller"
http://www.realtek.com/products/productsView.aspx?Langid=1&PNid=21&PFid=59&Level=5&Conn=4&ProdID=378

Realtek's crappy driver: https://github.com/NextThingCo/RTL8723DS
