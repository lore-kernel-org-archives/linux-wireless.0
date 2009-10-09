Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:6750 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbZJIOgr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 10:36:47 -0400
Message-ID: <4ACF4A0C.60508@lwfinger.net>
Date: Fri, 09 Oct 2009 09:34:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Miguel Boton <waninkoko@gmail.com>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	mb@bu3sch.de, linville@tuxdriver.com, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: add 'struct b43_wl' missing declaration
References: <200910091613.53960.mboton@gmail.com>
In-Reply-To: <200910091613.53960.mboton@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/09/2009 09:13 AM, Miguel Boton wrote:
> 'struct b43_wl' declaration is missing at 'leds.h'.
> It should be declared to avoid getting some GCC warnings at 'b43_leds_unregister'.
> 
> Signed-off-by: Miguel Botón <mboton@gmail.com>

What architecture? There must be something strange with your
configuration as I see no such warnings. Please post your .CONFIG.

Larry

