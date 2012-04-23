Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40401 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2DWHOA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 03:14:00 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Message-ID: <20373.271.262245.296570@gargle.gargle.HOWL> (sfid-20120423_091406_739553_8B80C150)
Date: Mon, 23 Apr 2012 12:43:19 +0530
To: George Nychis <gnychis@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: how to configure compat-wireless to force manual firmware load?
In-Reply-To: <CA+7oygft-wqhnkk5wwondb57WuN2hLkVDKMXwKoaK+p9sZwAcw@mail.gmail.com>
References: <CA+7oygft-wqhnkk5wwondb57WuN2hLkVDKMXwKoaK+p9sZwAcw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

George Nychis wrote:
> I was using an older version of compat-wireless, specifically a build
> from May 2011.  In that release of compat-wireless, the firmware was
> loaded manually using a filesystem mounted in /sys.
> 
> I recently downloaded a newer version of compat-wireless:
> compat-wireless-3.0.9-1.  In this version, it appears to spawn a
> kernel thread to check /lib/firmware for the firmware and load it.  If
> it is present, it loads the firmware, otherwise it fails saying that
> it cannot be found.
> 
> I am having trouble with the automatic load:
> <3>[  178.957584] otg_err: in s5pc110_otghcd_urb_dequeue()::00508
> <3>[  178.958650] => fail to cancel_transfer()
> <7>[  178.959879] usb 1-1.2: hcd_unlink_urb d13aa200 fail -1
> <7>[  178.962510] usb 1-1.2: khubd timed out on ep0out len=0/4096
> <3>[  178.963274] usb 1-1.2: ath9k_htc: Firmware - htc_7010.fw download failed
> <4>[  178.971658] ath9k_htc: probe of 1-1.2:1.0 failed with error -22

The FW is found, but transferring it to the device fails for some reason.
Can you give more details about the platform ?

Sujith
