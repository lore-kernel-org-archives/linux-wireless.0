Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:47197 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1HKNmP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 09:42:15 -0400
Received: by iye16 with SMTP id 16so50253iye.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 06:42:15 -0700 (PDT)
Message-ID: <4E43DC34.9010106@lwfinger.net> (sfid-20110811_154218_953601_448C97B3)
Date: Thu, 11 Aug 2011 08:42:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 3/3] b43: support new TX header, noticed to be used by
 598.314+ fw
References: <1313068036-13608-1-git-send-email-zajec5@gmail.com> <1313068036-13608-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1313068036-13608-3-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/11/2011 08:07 AM, Rafał Miłecki wrote:
>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
>   drivers/net/wireless/b43/b43.h  |    3 ++-
>   drivers/net/wireless/b43/main.c |    4 +++-
>   drivers/net/wireless/b43/xmit.c |   22 ++++++++++++++++++++++
>   drivers/net/wireless/b43/xmit.h |   19 +++++++++++++++++++
>   4 files changed, 46 insertions(+), 2 deletions(-)

These 3 patches tested with 14e4:4311 and 508.184 firmware.

Larry

