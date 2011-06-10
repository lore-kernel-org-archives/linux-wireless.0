Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60221 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab1FJLkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 07:40:20 -0400
Received: by qwk3 with SMTP id 3so1172977qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2011 04:40:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307642840-3043-1-git-send-email-arend@broadcom.com>
References: <1307642840-3043-1-git-send-email-arend@broadcom.com>
Date: Fri, 10 Jun 2011 13:40:19 +0200
Message-ID: <BANLkTim4p+jjm3iT63Lum146K38iGgvhWw@mail.gmail.com> (sfid-20110610_134046_864464_4D77D913)
Subject: Re: [PATCH] drivers: bcma: export bcma_core_disable() function
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/9 Arend van Spriel <arend@broadcom.com>:
> In the brcm80211 driver we disable the 80211 core when the driver is
> 'down'. The bcma_core_disable() function exactly does the same as
> our implementation so exporting this function makes sense.

Michael said we should not do do such a exporting without getting
users within the same patch serie.

-- 
Rafał
