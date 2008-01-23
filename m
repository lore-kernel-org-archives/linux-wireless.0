Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:38059 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYAWVgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 16:36:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Subject: Re: [PATCH] rfkill: add the WiMAX radio type
Date: Wed, 23 Jan 2008 22:35:01 +0100
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
References: <200801231324.39483.inaky@linux.intel.com>
In-Reply-To: <200801231324.39483.inaky@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801232235.01539.mb@bu3sch.de> (sfid-20080123_213647_396114_37AFF986)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 January 2008 22:24:38 Inaky Perez-Gonzalez wrote:
> @@ -150,7 +154,7 @@ static const struct input_device_id rfki
>  		.keybit = { [BIT_WORD(KEY_WLAN)] = BIT_MASK(KEY_WLAN) },
>  	},
>  	{
> -		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
> + 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,

Why are you adding a bogus whitespace to the start of the line here?

>  		.evbit = { BIT_MASK(EV_KEY) },
>  		.keybit = { [BIT_WORD(KEY_BLUETOOTH)] = BIT_MASK(KEY_BLUETOOTH) },
>  	},

-- 
Greetings Michael.
