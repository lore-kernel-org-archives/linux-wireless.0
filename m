Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49860 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab1FFKvK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 06:51:10 -0400
Received: by qwk3 with SMTP id 3so1582545qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 03:51:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307356322.28734.11.camel@dev.znau.edu.ua>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
	<1307311658-15853-4-git-send-email-hauke@hauke-m.de>
	<BANLkTi=T6xO9q+vOCk5Fu+2J_nUTwX3dcg@mail.gmail.com>
	<1307356322.28734.11.camel@dev.znau.edu.ua>
Date: Mon, 6 Jun 2011 12:51:09 +0200
Message-ID: <BANLkTimkKFAEfbKaWo81=uyuDS=gjESHAw@mail.gmail.com> (sfid-20110606_125114_647922_5E957756)
Subject: Re: [RFC][PATCH 03/10] bcma: add embedded bus
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
	linux-mips@linux-mips.org, mb@bu3sch.de, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 6 czerwca 2011 12:32 użytkownik George Kashperko
<george@znau.edu.ua> napisał:
> Hi,
>
>> Hauke,
>>
>> My idea for naming schema was to use:
>> bcma_host_TYPE_*
>>
>> Like:
>> bcma_host_pci_*
>> bcma_host_sdio_*
>>
>> You are using:
>> bcma_host_bcma_*
>>
>> What do you think about changing this to:
>> bcma_host_embedded_*
>> or just some:
>> bcma_host_emb_*
>> ?
>>
>> Does it make more sense to you? I was trying to keep names in bcma
>> really clear, so every first-time-reader can see differences between
>> hosts, host and driver, etc.
>
> how about bcma_host_soc ?

We get then inconsistency with "BCMA_HOSTTYPE_EMBEDDED". I'd like to
1) See something like bcma_host_emb...
xor
2) Use bcma_host_soc_* and BCMA_HOSTTYPE_SOC

-- 
Rafał
