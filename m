Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:40070 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab3ANMRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 07:17:14 -0500
Received: by mail-lb0-f181.google.com with SMTP id ge1so2902119lbb.12
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2013 04:17:12 -0800 (PST)
Message-ID: <50F3F743.1000802@gmail.com> (sfid-20130114_131733_389290_4BF3087E)
Date: Mon, 14 Jan 2013 13:17:07 +0100
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Solomon Peachy <pizza@shaftnet.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: RFCv3: ST-E CW1200 WLAN driver
References: <1357999575-12838-1-git-send-email-pizza@shaftnet.org>
In-Reply-To: <1357999575-12838-1-git-send-email-pizza@shaftnet.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-01-12 15:06, Solomon Peachy wrote:
> Here's the third patch series, still under drivers/staging.
>

I believe this driver should go into driver/net/wireless considering 
that we have a maintainer, it has passed wifi cert and is in use in 
production devices.

I have a few patches queued up for you that fixes the last sparse 
warnings too...

Cheers,

Pontus

