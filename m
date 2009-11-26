Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:57227 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965049AbZKZAlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 19:41:45 -0500
Received: by iwn1 with SMTP id 1so173380iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2009 16:41:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B0DCC15.3090506@openwrt.org>
References: <1259180955-2145-1-git-send-email-juhosg@openwrt.org>
	<20091125213857.GM5006@tux> <4B0DCC15.3090506@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 25 Nov 2009 16:41:31 -0800
Message-ID: <43e72e890911251641qdb08114p4d5ccc4487efd34c@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: enable 2GHz band only if the device
	supports it
To: Felix Fietkau <nbd@openwrt.org>
Cc: Gabor Juhos <juhosg@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 25, 2009 at 4:30 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Luis R. Rodriguez wrote:
>> On Wed, Nov 25, 2009 at 12:29:15PM -0800, Gabor Juhos wrote:
>>> Currently, the 2GHz band is enabled unconditionally, even if the device
>>> does not support it.
>>
>> This is true, but we don't have any 11n 5 GHz only devices,
>> The patch is fine too though but it'd be better if you fail
>> with a proper ath_print ATH_DBG_FATAL message if neither band
>> has been marked as supported.
> We do have some ;)
> Ubiquiti Networks has a few Python+Merlin based devices that are 5GHz
> only, and we're working on supporting them.

Sexy!

  Luis
