Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49698 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab0DVOQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 10:16:45 -0400
Received: by vws20 with SMTP id 20so260878vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 07:16:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19407.50651.473633.812258@gargle.gargle.HOWL>
References: <19407.50651.473633.812258@gargle.gargle.HOWL>
Date: Thu, 22 Apr 2010 22:16:44 +0800
Message-ID: <k2zd82e647a1004220716h273247bcl9c95995d15492f7@mail.gmail.com>
Subject: Re: [PATCH 2/9] ath9k_htc: Handle device unplug properly
From: Ming Lei <tom.leiming@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/22 Sujith <Sujith.Manoharan@atheros.com>:
> When the USB device has been unplugged, there is
> no point in trying to send commands to the target.
> Fix this by denying all WMI commands in such a case.
>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

Tested-by: Ming Lei <tom.leiming@gmail.com>

-- 
Lei Ming
