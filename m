Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:43964 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821Ab0G2SE5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 14:04:57 -0400
Message-ID: <4C51C2C4.7050207@bu3sch.de>
Date: Thu, 29 Jul 2010 20:04:52 +0200
From: =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@wfinger.net>
Subject: Re: [PATCH] b43: update hw/fw version info in wiphy struct
References: <1280424853-18954-1-git-send-email-linville@tuxdriver.com> (sfid-20100729_194523_073564_FFFFFFFFA02F8A4A)
In-Reply-To: <1280424853-18954-1-git-send-email-linville@tuxdriver.com> (sfid-20100729_194523_073564_FFFFFFFFA02F8A4A)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/29/2010 07:34 PM, John W. Linville wrote:
> +	wiphy->hw_version = dev->dev->bus->chip_id;

Hm, well. Is hw_version of any use, actually? How does ethtool display
it? I guess it does not use BCD (chip_id is BCD encoded).

What about using the wireless-core revision? It is slightly more usable
than the chip_id.

-- 
Greetings Michael.
