Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:47959 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab0LFSnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 13:43:05 -0500
Received: by gwb20 with SMTP id 20so6773099gwb.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 10:43:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101206042812.GB28134@monopoli.naic.edu>
References: <AANLkTi=YT1V-kr-tAmNfSBPPEGk39H37RoNkx5txhnD7@mail.gmail.com>
	<20101203001052.GA16808@monopoli.naic.edu>
	<AANLkTinLaa+dOiq67DAt+KYfnxUEkNgWEiE2x1NtT9RE@mail.gmail.com>
	<AANLkTim-hexpFnV_DfKGM53vWo1-5W6fbK4e+jLnb5fB@mail.gmail.com>
	<20101203202321.GA21937@monopoli.naic.edu>
	<AANLkTi=qvZ-Uj1T=9Xc8LyyxKvgNw4CKV8Zx2fDfo4uH@mail.gmail.com>
	<20101204033646.GA22662@monopoli.naic.edu>
	<AANLkTik=nbdNUU7gzO9V17fHWZibc2LjuXDgpeRDztoM@mail.gmail.com>
	<20101204134732.GA24216@monopoli.naic.edu>
	<AANLkTinU+Xv+gNSTJnEz_tYPhcXRf=kEfkyyeuN0QPFt@mail.gmail.com>
	<20101206042812.GB28134@monopoli.naic.edu>
Date: Mon, 6 Dec 2010 18:43:04 +0000
Message-ID: <AANLkTimC4NkPhpmOUWHvWpCZGvXjM1GkZCUja=Qhr=9N@mail.gmail.com>
Subject: Re: orinoco_cs module and WPA not working
From: Dave Kilroy <kilroyd@googlemail.com>
To: Giacomo Comes <comes@naic.edu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I have been testing your patches and I can confirm that now the orinoco
> driver is working properly for me. Using directly wpa_supplicant and using
> networkmanager.
> Thank you very much for your work.

No problem.

> The only issue still not fixed is the suspend/resume timeout.
> Can you help also with that?

Absolutely. With the latest patches, please just do a suspend resume,
and post the dmesg output. Also let me know what the value of
CONFIG_HERMES_CACHE_FW_ON_INIT is.
