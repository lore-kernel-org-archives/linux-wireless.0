Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34665 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbbGMHfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2015 03:35:13 -0400
Received: by wgkl9 with SMTP id l9so18658023wgk.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2015 00:35:12 -0700 (PDT)
Received: from [1.1.8.48] (206.Red-213-97-173.staticIP.rima-tde.net. [213.97.173.206])
        by smtp.googlemail.com with ESMTPSA id h9sm17003021wjx.20.2015.07.13.00.35.12
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2015 00:35:12 -0700 (PDT)
Message-ID: <55A36A2E.70005@gmail.com> (sfid-20150713_093518_350946_00A43FCE)
Date: Mon, 13 Jul 2015 09:35:10 +0200
From: jorge Dominguez <jmadomrod@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Realtek RTL8723as Blueetooth driver
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Currently we have a development proyect with IMX6 freescale processor 
and a rtl8723as wifi+BT chipset to provide wifi and BT 4.0 funcionality.

We have problems with UART driver for bluetooth on rtl8723as chipset 
with Low Energy BLE devices. Connections with BLE dont work properly. We 
believe is a rtl8723a_fw issue.

Could anybody provide reference for Bluetooth driver for rtl8723as chipset?

Best Regards,
Jorge
