Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:41249 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbZHTVEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 17:04:24 -0400
Received: by iwn42 with SMTP id 42so95894iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 14:04:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250796364.3311.0.camel@macbook.infradead.org>
References: <1250793627-22396-1-git-send-email-lrodriguez@atheros.com>
	<1250796364.3311.0.camel@macbook.infradead.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 20 Aug 2009 14:04:05 -0700
Message-ID: <43e72e890908201404p3b1344d5gc9c568d84dea9f96@mail.gmail.com>
Subject: Re: [PATCH] atheros: add ar9170.fw 1-stage firmware
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-wireless@vger.kernel.org,
	Stephen Chen <Stephen.Chen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 20, 2009 at 12:26 PM, David Woodhouse<dwmw2@infradead.org> wrote:
> On Thu, 2009-08-20 at 11:40 -0700, Luis R. Rodriguez wrote:
>>
>> Here is a resend, noticed today this wasn't yet in the tree.
>>
>>  ar9170.fw |  Bin 0 -> 15960 bytes
>>  1 files changed, 0 insertions(+), 0 deletions(-)
>>  create mode 100644 ar9170.fw
>
> Needs patch to WHENCE file.

On second thought people already know where to find this file as
documented on the wiki, and since users are reporting some issues with
it we may as well wait for a release of the open fw which is based on
the same code as the 1 stage fw.

So if people can start testing that it would help.

 Luis
