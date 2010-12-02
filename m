Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35071 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085Ab0LBP1K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 10:27:10 -0500
Message-ID: <4CF7BAC9.4060900@openwrt.org>
Date: Thu, 02 Dec 2010 16:27:05 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Walter Goldens <goldenstranger@yahoo.com>
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [PATCH] compat: backport LED class software blinking
References: <400806.62671.qm@web56803.mail.re3.yahoo.com>
In-Reply-To: <400806.62671.qm@web56803.mail.re3.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-12-02 2:14 PM, Walter Goldens wrote:
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
> 
>> +}
>> +EXPORT_SYMBOL(compat_led_brightness_set);
>> +
>> +void compat_led_classdev_unregister(struct led_classdev
>> *led_cdev)
>> +{
> 
> I think this patch is causing problems in compat-wireless. It compiles fine, but some drivers fail to load:
I think this was fixed in Hauke's patch
'compat: fix build with CONFIG_LEDS_CLASS=m'

- Felix
