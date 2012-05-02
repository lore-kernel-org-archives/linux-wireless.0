Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54901 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab2EBPWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 11:22:41 -0400
Received: by vcqp1 with SMTP id p1so513183vcq.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 May 2012 08:22:41 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 2 May 2012 11:22:40 -0400
Message-ID: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com> (sfid-20120502_172245_353775_52F2EBD2)
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
From: Kevin Groeneveld <kgroeneveld@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: dmitry.tarnyagin@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>Please find below in the patchset implementation of a new driver for
>the ST-Ericsson cw1200 wlan device.

Hello Dmitry,

What firmware version is this driver tested with?  Where can I get the
firmware files?

I have build 328 and 380 but I cannot get the driver to work with
either of these.  Everything looks like it is working okay but when I
run "iw wlan0 scan" it does not find anything.  The debugfs counters
show I am not receiving any valid packets:

PlcpErrors:             6
FcsErrors:              0
TxPackets:              22
RxPackets:              0
RxPacketErrors:         6
RxDecryptionFailures:   0
RxMicFailures:          0
RxNoKeyFailures:        0
TxMulticastFrames:      44
TxFramesSuccess:        0
TxFrameFailures:        0
TxFramesRetried:        0
TxFramesMultiRetried:   0
RxFrameDuplicates:      0
RtsSuccess:             0
RtsFailures:            0
AckFailures:            0
RxMulticastFrames:      0
RxFramesSuccess:        0
RxCMACICVErrors:        0
RxCMACReplays:          0
RxMgmtCCMPReplays:      0


Thanks,

Kevin
