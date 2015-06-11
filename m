Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36795 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbbFKJH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 05:07:28 -0400
Received: by wigg3 with SMTP id g3so69631726wig.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 02:07:27 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 11 Jun 2015 11:07:27 +0200
Message-ID: <CAEk6gTBzoR4FCJp0xo=AOOmbeE7ekROpUf0+_yKMBoqUHTgHWw@mail.gmail.com> (sfid-20150611_110733_670223_D6B9AA9E)
Subject: RTL8723BS BLE Support
From: Drasko DRASKOVIC <drasko.draskovic@gmail.com>
To: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Rathgeb Paul <paul.rathgeb@skynet.be>,
	uros petrevski <uros.petrevski@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
I can see here: https://github.com/lwfinger/rtl8723bs_bt Bluetooth
support for RTL8723BS chip support. This chip should support Bluetooth
Low Energy, based on this -
https://wikidevi.com/wiki/Realtek_RTL8723BS_Combo_Module_(SDIO),
although I do not see BLE mention in the datasheet:
http://space.cechina.cn/infosharedownload.aspx?id=1011.

I was wondering about the satate of this driver and BLE (not only
Bluetooth, but specifically Bletooth Low Energy) support in Linux for
this WiFi chip - did anybody use it, have this been proven to work for
someone?

Best regards,
Drasko
