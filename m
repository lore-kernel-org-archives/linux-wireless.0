Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:20026 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126Ab0BNBhs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 20:37:48 -0500
Subject: Re: [PATCH 0/3] rt2x00: rt2800 detection improvements.
From: Pavel Roskin <proski@gnu.org>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
In-Reply-To: <1266090949-5468-1-git-send-email-gwingerde@gmail.com>
References: <1266090949-5468-1-git-send-email-gwingerde@gmail.com>
Content-Type: text/plain
Date: Sat, 13 Feb 2010 20:37:31 -0500
Message-Id: <1266111451.32423.14.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-02-13 at 20:55 +0100, Gertjan van Wingerde wrote:
> Some general rt2800 detection improvements. This make SOC a special
> interface, and thus simplifying SOC detection a bit, and unifies
> rt2800pci and rt2800usb further in detecting with what kind of 
> rt2800 device we are dealing with.
> 
> Gertjan van Wingerde (3):
>   rt2x00: Introduce SoC interface type.
>   rt2x00: Reorganize RT chipset setting for PCI/SOC devices.
>   rt2x00: rework RT chipset and revision determination for PCI an SOC
>     devices.

Rested-by: Pavel Roskin <proski@gnu.org>

Tested with rt73usb and rt2800pci.  wpa_supplicant is working fine.  No
new sparse warnings are introduced.

-- 
Regards,
Pavel Roskin
