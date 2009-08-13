Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:62977 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbZHMVES convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 17:04:18 -0400
Received: by yxe5 with SMTP id 5so1348947yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 14:04:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A847F2A.8000301@lwfinger.net>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
	<1250191909-21682-5-git-send-email-lrodriguez@atheros.com>
	<4A847F2A.8000301@lwfinger.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 13 Aug 2009 14:03:58 -0700
Message-ID: <43e72e890908131403s1d3a7f47ted2980ff4841b65@mail.gmail.com>
Subject: Re: [PATCH 04/20] wireless: move p54 and prism54 drivers closeer on
	kconfig
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 13, 2009 at 2:01 PM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
> Luis R. Rodriguez wrote:
>> Cc: Christian Lamparter <chunkeey@web.de>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  drivers/net/wireless/Kconfig |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> I think the p54 and p54usb configuration ends up in the wrong place.
> Was there supposed to be a Patch 03/20? I didn't get that one.

Yeah it seems the mailserver ate it. I'll respin.

  Luis
