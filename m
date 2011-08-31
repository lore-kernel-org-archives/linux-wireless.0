Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41964 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244Ab1HaVlR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 17:41:17 -0400
Message-ID: <4E5EAA76.30901@hauke-m.de> (sfid-20110831_234120_372554_FC90A225)
Date: Wed, 31 Aug 2011 23:41:10 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: mcgrof@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] compat: add cordic lib
References: <1314184839-13279-1-git-send-email-hauke@hauke-m.de> <1314184839-13279-2-git-send-email-hauke@hauke-m.de> <CAGRGNgX7=A=kRqSoxDNhW2hZSMip=oZd-gy5pWCZekN2jUpG2Q@mail.gmail.com>
In-Reply-To: <CAGRGNgX7=A=kRqSoxDNhW2hZSMip=oZd-gy5pWCZekN2jUpG2Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2011 04:06 PM, Julian Calaby wrote:
> Hauke,
> 
> On Wed, Aug 24, 2011 at 21:20, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> compat/cordic.c was copied from lib/cordic.c and include/linux/cordic.h was
>> copied from include/linux/cordic.h
> 
> Stupid question: If we have a full kernel tree available to update
> compat, can't we just copy these files from there?
> 
> Thanks,
> 

Hi Julian,

I am working on extending the script to copy these files and the other
copied from the kernel image.

Hauke
