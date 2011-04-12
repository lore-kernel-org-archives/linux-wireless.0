Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51321 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab1DLKtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 06:49:43 -0400
Received: by qyg14 with SMTP id 14so4541379qyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 03:49:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4da3e0e7.OIpXziberWyLiFw6%Larry.Finger@lwfinger.net>
References: <4da3e0e7.OIpXziberWyLiFw6%Larry.Finger@lwfinger.net>
Date: Tue, 12 Apr 2011 12:49:42 +0200
Message-ID: <BANLkTim1YYpqQocCe_O2Y4-E1B5Jd9Rc7Q@mail.gmail.com>
Subject: Re: [PATCH v2] rt2800usb: Add seven new USB IDs
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, marked86@gmail.com,
	helmut.schaa@googlemail.com, gwingerde@gmail.com,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 12, 2011 at 7:19 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Mark Davis <marked86@gmail.com>
>
> Adds USB IDs for seven previously missing devices. Additionally, all
> instances of 'Conceptronic' have been replaced by the OEM name.
>
> Devices added are..
> 0411:01a2 - Buffalo WLI-UC-GNM, RT3070V
> 0586:341e - ZyXEL NWD2105, RT3070
> 13b1:002f - Linksys AE1000, RT3572
> 13b1:0031 - Cisco / Linksys AM10, RT3072
> 14b2:3c2c - Keebox W150NU / Alpha Networks WUS-N12, RT3070
> 157e:3013 - TRENDnet TEW-645UB, RT2770+RT2720
> 15a9:0012 - Airlink AWLL7025 / Gemtek WUBR-208N, RT2870+RT2850
>
> Signed-off-by: Mark Davis <marked86@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
