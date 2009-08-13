Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:15975 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbZHMVBe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 17:01:34 -0400
Received: by wf-out-1314.google.com with SMTP id 26so318855wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 14:01:35 -0700 (PDT)
Message-ID: <4A847F2A.8000301@lwfinger.net>
Date: Thu, 13 Aug 2009 16:01:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@web.de>
Subject: Re: [PATCH 04/20] wireless: move p54 and prism54 drivers closeer
 on kconfig
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com> <1250191909-21682-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250191909-21682-5-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Cc: Christian Lamparter <chunkeey@web.de>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

I think the p54 and p54usb configuration ends up in the wrong place.
Was there supposed to be a Patch 03/20? I didn't get that one.

Larry

