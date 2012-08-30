Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:1208 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104Ab2H3VOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 17:14:47 -0400
Message-ID: <503FD7C5.7030501@gmail.com> (sfid-20120830_231453_150309_1A8B3908)
Date: Thu, 30 Aug 2012 23:14:45 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 10/17] rt2x00: Fix rt2500usb rfkill polling prior to interface
 start.
References: <1346355248-5331-10-git-send-email-gwingerde@gmail.com> <1346360670-6498-1-git-send-email-gwingerde@gmail.com> <1346360670-6498-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1346360670-6498-2-git-send-email-gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/12 23:04, Gertjan van Wingerde wrote:
> We need to program the rfkill switch GPIO pin direction to input at
> device initialization time, not only when the interface is brought up.
> Doing this only when the interface is brought up could lead to rfkill
> detecting the switch is turned on erroneously and inability to create
> the interface and bringing it up.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> Cc: <stable@vger.kernel.org>

All, I seem to have goofed up somewhere. Please disregard all patches
that claim to be from a 17 patch series. These are strange duplicates
that should not have been sent.

---
Gertjan.

