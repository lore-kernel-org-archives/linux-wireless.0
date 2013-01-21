Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:62645 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab3AUUF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 15:05:27 -0500
Received: by mail-la0-f43.google.com with SMTP id ed20so2117641lab.16
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jan 2013 12:05:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50FA04B6.8080703@gmail.com>
References: <E1TwInB-0003VY-Jh@sipsolutions.net> <50FA04B6.8080703@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 21 Jan 2013 12:05:05 -0800
Message-ID: <CAB=NE6UHBZhg7L_Oh5EayLBQyY=fceqUBtfz=kEFXG_u2Ko9TQ@mail.gmail.com> (sfid-20130121_210531_348240_81D50681)
Subject: Re: [ANN] crda: v1.1.3
To: Richard Farina <sidhayn@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 18, 2013 at 6:28 PM, Richard Farina <sidhayn@gmail.com> wrote:
> On 01/18/2013 03:44 PM, wireless@sipsolutions.net wrote:
>> A new release of crda (v1.1.3) is available at:
>>
>> http://wireless.kernel.org/download/crda/crda-1.1.3.tar.bz2
>>
>> SHA1 sum: 6e0adbfc0f5418a03d7d708bd39d52cd1325b511
>>
>> Here is the short log of the changes (since v1.1.2)
>> included in this release:
>>
>> Luis R. Rodriguez (15):
>>       crda: synch up nl80211.h
>>       crda: fix null string assumption for alpha2
>>       crda: add support to send DFS master region
>>       crda: use stdint.h instead of linux/types.h
>>       crda: move country2rd() and its helper to reglib.c
>>       crda: add a reglib iterator reglib_for_each_country()
>>       crda: make intersect.c use reglib_for_each_country()
>>       crda: close fd upon leaving
>>       crda: add new reglib_get_country_alpha2()
>>       crda: add dfs_region to the ieee80211_regdomain data structure
>>       crda: make crda use reglib_get_country_alpha2()
>>       crda: clean header files
>>       crda: make country2rd() static
>>       crda: make usage of regdb.h exclusive to reglib.c
>>       crda: rename reglib_get_*() routines
>>
>> Stefan Lippers-Hollmann (1):
>>       crda: add nested support for libnl-3.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> I get three warnings when building that look like that may matter:

Its just a warning but can you try adding the following path (in another e-mail)

  Luis
