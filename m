Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63656 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0KLTg1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 14:36:27 -0500
Received: by qwi2 with SMTP id 2so118399qwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 11:36:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <22205438.1071289487479070.JavaMail.wlan@CHBU500181>
References: <19249879.711289486676029.JavaMail.wlan@CHBU500181>
	<22205438.1071289487479070.JavaMail.wlan@CHBU500181>
Date: Fri, 12 Nov 2010 14:36:26 -0500
Message-ID: <AANLkTi=tqs=MHkGMsHZCw0ad_+J2LouOXhtT2VFrrgBd@mail.gmail.com>
Subject: Re: [PATCH 4/9] ath5k: AHB port. Use generic eeprom read from common
 ath_bus_opts structure.
From: Bob Copeland <me@bobcopeland.com>
To: Wojciech Dubowik <dubowoj@neratec.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 9:58 AM, Wojciech Dubowik <dubowoj@neratec.com> wrote:
> Replaces specific pci eeprom read function.
>
> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>

Not sure why the function has to be renamed, but otherwise looks reasonable.

-- 
Bob Copeland %% www.bobcopeland.com
