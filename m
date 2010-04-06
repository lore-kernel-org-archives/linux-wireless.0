Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:36018 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab0DFV2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 17:28:44 -0400
Received: by ewy20 with SMTP id 20so210920ewy.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Apr 2010 14:28:42 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] wireless: rt2x00: delete duplicates ids in rt73usb rt2500usb
Date: Tue, 6 Apr 2010 23:28:40 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, gwingerde@gmail.com
References: <1270574791-14006-1-git-send-email-xose.vazquez@gmail.com>
In-Reply-To: <1270574791-14006-1-git-send-email-xose.vazquez@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <201004062328.40656.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 06 April 2010, Xose Vazquez Perez wrote:
> Follow the precepts of the ralink drivers.
> 
> (0x050d, 0x7050) is only found in:
> 
> RT25USB-SRC-V2.0.8.0/rt2570sw.h:#define RTVID8                  0x050D //ralink
> RT25USB-SRC-V2.0.8.0/rt2570sw.h:#define RTPID8                  0x7050
> RT25USB-SRC-V2.0.8.0/rt2570sw.h: {USB_DEVICE(RTVID8,RTPID8)},
> 
> and (0x050d, 0x705a) (0x1371, 0x9022) (0x148f, 0x2573) are only in:
> 
> 2009_0713_RT73_Linux_STA_Drv1.1.0.3/Module/rtmp_def.h: {USB_DEVICE(0x050d,0x705a)}, /* Belkin */
> 2009_0713_RT73_Linux_STA_Drv1.1.0.3/Module/rtmp_def.h: {USB_DEVICE(0x1371,0x9022)}, /* CNet */
> 2009_0713_RT73_Linux_STA_Drv1.1.0.3/Module/rtmp_def.h: {USB_DEVICE(0x148f,0x2573)}, /* Ralink */
> 
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

I have my doubts about this one.
Gertjan, do you consider it wise to remove these ID's?

Ivo
