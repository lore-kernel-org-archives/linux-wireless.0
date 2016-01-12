Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:33500 "EHLO
	mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbcALXSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 18:18:30 -0500
Received: by mail-vk0-f65.google.com with SMTP id n1so6248918vkb.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2016 15:18:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1452560419.7773.87.camel@perches.com>
References: <1452558775-21532-1-git-send-email-chaehyun.lim@gmail.com>
	<1452558775-21532-2-git-send-email-chaehyun.lim@gmail.com>
	<1452560419.7773.87.camel@perches.com>
Date: Wed, 13 Jan 2016 08:18:29 +0900
Message-ID: <CAKV=isuDM=pOMkYwQSmt2QQB9LGpwnCZ-scuWZ_7OXsG4kWJew@mail.gmail.com> (sfid-20160113_001842_369257_2EAB5BEB)
Subject: Re: [PATCH 2/5] staging: wilc1000: remove typedef from struct wilc_cfg_byte_t
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	"tony.cho" <tony.cho@atmel.com>, glen.lee@atmel.com,
	leo.kim@atmel.com, linux-wireless <linux-wireless@vger.kernel.org>,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you for your comment.
I'll resend again this patch after considering your suggestion.

regards
Chaehyun Lim

On Tue, Jan 12, 2016 at 10:00 AM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2016-01-12 at 09:32 +0900, Chaehyun Lim wrote:
>> This patch removes typedef from struct wilc_cfg_byte_t and renames it to
>> wilc_cfg_byte.
>
> Is this really a good name?
>
>> diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
> []
>> @@ -10,10 +10,10 @@
>>  #ifndef WILC_WLAN_CFG_H
>>  #define WILC_WLAN_CFG_H
>>
>> -typedef struct {
>> +struct wilc_cfg_byte {
>>       u16 id;
>>       u16 val;
>> -} wilc_cfg_byte_t;
>> +};
>
> val is a u16, calling it cfg_byte seems misleading.
>
>
