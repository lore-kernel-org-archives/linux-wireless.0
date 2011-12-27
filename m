Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:1327 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645Ab1L0RbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 12:31:11 -0500
Message-ID: <4EFA00DC.8070007@gmail.com> (sfid-20111227_183114_560286_054AC983)
Date: Tue, 27 Dec 2011 18:31:08 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: John W Linville <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, helmut.schaa@googlemail.com,
	IvDoorn@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2800usb: Move ID out of unknown
References: <4ef9f8d7.gS21SIcvWuSTbCy9%Larry.Finger@lwfinger.net>
In-Reply-To: <4ef9f8d7.gS21SIcvWuSTbCy9%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On 12/27/11 17:56, Larry Finger wrote:
> Testing on the openSUSE wireless forum has shown that a Linksys
> WUSB54GC v3 with USB ID 1737:0077 works with rt2800usb when the ID is
> written to /sys/.../new_id. This ID can therefore be moved out of UNKNOWN.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

We've got these devices is the UNKNOWN section because we don't know
what chipset is used by these devices (and therefore the level of
support is unknown).

Do you know which chipset is used by this device?

This should be reported in dmesg when CONFIG_RT2X00_DEBUG is enabled.

---
Gertjan.
