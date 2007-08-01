Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:48269 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbXHARBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 13:01:24 -0400
Received: by fk-out-0910.google.com with SMTP id z23so217465fkz
        for <linux-wireless@vger.kernel.org>; Wed, 01 Aug 2007 10:01:22 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Please pull 'upstream' branch of rt2x00
Date: Wed, 1 Aug 2007 19:05:29 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200707312036.49060.IvDoorn@gmail.com>
In-Reply-To: <200707312036.49060.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708011905.29675.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Thanks for the quick pull on rt2x00.git,
but I have a short question:

> Ivo van Doorn (25):
>       rt2x00: Remove rt73usb_get_tsf
>       rt2x00: Put rf register value detection in function
>       rt2x00: Don't toggle tuner bit for non-RF2523 chips
>       rt2x00: Add reset_tuner handler
>       rt2x00: rt2500usb needs to reset BBP 24, 25 and 61
>       rt2x00: Cleanup RF register reading/writing
>       rt2x00: Add RF register contents to Debugfs
>       rt2x00: Fix invalid RF array reading
>       rt2x00: Increase RF_SIZE
>       rt2x00: rt2x00pci should use rf_size
>       rt2x00: Correctly handle RF 0 writing
>       rt2x00: Rename init_hw -> probe_hw
>       rt2x00: Move interface init/deinit into rt2x00dev
>       rt2x00: Fix interface opening/closing on suspend/resume
>       rt2x00: Lindent
>       rt2x00: Call all configure handlers during resume
>       rt2x00: Big rt2x00 cleanup
>       rt2x00: Add Multicast/Broadcast filtering
>       rt2x00: Include <linux/delay.h>
>       rt2x00: Periodically read statistics
>       rt2x00: Don't check for preamble in RXdone
>       rt2x00: Configure type during add_interface
>       rt2x00: Add Signal reporting

The above have been merged nicely,
but where did the following patch go to?

>       rt2x00: rt2x00 2.0.5

Was this intentionally dropped,
or was there a weird git problem somewhere?

Thanks,

Ivo
