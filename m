Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:37216 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab3GaSGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 14:06:22 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so895746wgh.7
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 11:06:21 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <51F94EEA.8040503@gespk.com>
References: <51F94EEA.8040503@gespk.com>
Date: Wed, 31 Jul 2013 20:06:21 +0200
Message-ID: <CA+icZUX4jhb72CkTdnCV5buTsFTq_r1JLecTiJuqU2p05+zFNQ@mail.gmail.com> (sfid-20130731_200625_860396_1C89CF9E)
Subject: Re: Intel WiFi Link 4965AGN - Failed, HW not ready
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Abdur Rehman <arqureshi@gespk.com>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 31, 2013 at 7:52 PM, Abdur Rehman <arqureshi@gespk.com> wrote:
> Hi we are unable to load the driver for Intel 4965agn module on a linux
> system.
> We are seeing "HW not ready" error. Please see the log below
>
Hi,

can't say who is "we"... but /me sees no Linux-kernel version!
Attach a full dmesg - it does not hurt together with your kernel-config file?
Do you have installed a firmware? What firmware-version do you use?
... (have a look into docs on <wireless.kernel.org>?)...

Make "we" "us" "you" "me" $(hello-)world happy :-)!

- Sedat -

> modprobe iwlagn
> [ 54.690000] cfg80211: Using static regulatory domain info
> [ 54.700000] cfg80211: Regulatory domain: US
> [ 54.710000] (start_freq - end_freq @ bandwidth), (max_antenna_gain,
> max_eirp)
> [ 54.720000] (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
> [ 54.730000] (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [ 54.740000] (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [ 54.750000] (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [ 54.760000] (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [ 54.770000] (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
> [ 54.780000] cfg80211: Calling CRDA for country: US
> [ 55.080000] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux,
> 1.3.27k
> [ 55.090000] iwlagn: Copyright(c) 2003-2009 Intel Corporation
> [ 55.100000] PCI: enabling device 0000:04:00.0 (0000 -> 0002)
> [ 55.110000] iwlagn 0000:04:00.0: Detected Intel Wireless WiFi Link 4965AGN
> REV=0x0
> [ 55.120000] iwlagn 0000:04:00.0: Failed, HW not ready
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
