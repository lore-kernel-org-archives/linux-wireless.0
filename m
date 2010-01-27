Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:45698 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab0A0A2F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 19:28:05 -0500
Received: by yxe17 with SMTP id 17so4167205yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2010 16:28:04 -0800 (PST)
Message-ID: <4B5F8891.4000204@lwfinger.net>
Date: Tue, 26 Jan 2010 18:28:01 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Add callback for get_tsf
References: <4b5f7e98.WueiIRrKwMIrtoob%Larry.Finger@lwfinger.net> <3ace41891001261617w54e8c08dm5d317f7c2b17cba4@mail.gmail.com>
In-Reply-To: <3ace41891001261617w54e8c08dm5d317f7c2b17cba4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2010 06:17 PM, Hin-Tak Leung wrote:
> On Tue, Jan 26, 2010 at 11:45 PM, Larry Finger
> <Larry.Finger@lwfinger.net>  wrote:
>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>
> Acked-by: Hin-Tak Leung<htl10@users.sourceforge.net>
>
> Presumably this new api is needed and used by some userland tools (iw
> or other QoS-related tool?).

 From include/net/mac80211.h: "It is currently used for IBSS mode BSSID merging 
and debugging". Implementation of this callback is voluntary.

Larry

