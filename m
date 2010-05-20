Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:50681 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab0ETGwO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 02:52:14 -0400
Received: by fg-out-1718.google.com with SMTP id d23so401571fga.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 23:52:12 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v2 7/7] rt2x00: Fix HT40 operation in rt2800.
Date: Thu, 20 May 2010 08:52:03 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1274296671-13596-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1274296671-13596-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Message-Id: <201005200852.03136.helmut.schaa@googlemail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch 19 Mai 2010 schrieb Gertjan van Wingerde:
> Closer inspection of the legacy Ralink driver reveals that in case of HT40+
> or HT40- we must adjust the frequency settings that we program to the device.
> Implement the same adjustment in the rt2x00 code.
> 
> With this HT40 seems to work for all devices supported by rt2800pci and
> rt2800usb.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Yeah, that does the trick. Thanks for figuring this out.

Tested-by: Helmut Schaa <helmut.schaa@googlemail.com>
