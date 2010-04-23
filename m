Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50780 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab0DWHWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 03:22:21 -0400
Received: by vws14 with SMTP id 14so467014vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Apr 2010 00:22:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1272006625-6136-1-git-send-email-vnatarajan@atheros.com>
References: <1272006625-6136-1-git-send-email-vnatarajan@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 23 Apr 2010 00:22:00 -0700
Message-ID: <x2w43e72e891004230022ie6ecf227gc4a8989329c70165@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Avoid corrupt frames being forwarded to mac80211.
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ranga Rao Ravuri <ranga.ravuri@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 23, 2010 at 12:10 AM, Vivek Natarajan
<vnatarajan@atheros.com> wrote:
> If bit 29 is set, MAC H/W can attempt to decrypt the received aggregate
> with WEP or TKIP, eventhough the received frame may be a CRC failed
> corrupted frame.
>
> Reported-by: Johan Hovold <johan.hovold@lundinova.se>
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> Signed-off-by: Ranga Rao Ravuri <ranga.ravuri@atheros.com>

Is this a stable fix? If so please indicate. If not, please indicate why not :)

  Luis
