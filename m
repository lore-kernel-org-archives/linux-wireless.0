Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47492 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab1FTVPW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 17:15:22 -0400
Message-ID: <4DFFB865.6060105@hauke-m.de> (sfid-20110620_231525_624003_C776CD68)
Date: Mon, 20 Jun 2011 23:15:17 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	linux-mips@linux-mips.org, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com, arnd@arndb.de, sshtylyov@mvista.com
Subject: Re: [RFC v2 05/12] bcma: add mips driver
References: <1308520209-668-1-git-send-email-hauke@hauke-m.de> <1308520209-668-6-git-send-email-hauke@hauke-m.de> <BANLkTinCrAMa3bmTsKpu4y7QGbSiU9jMXQ@mail.gmail.com>
In-Reply-To: <BANLkTinCrAMa3bmTsKpu4y7QGbSiU9jMXQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/20/2011 01:44 AM, Julian Calaby wrote:
> Hauke,
> 
> One minor comment
> 
> On Mon, Jun 20, 2011 at 07:50, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
>> new file mode 100644
>> index 0000000..d49f9af
>> --- /dev/null
>> +++ b/drivers/bcma/driver_mips.c
>> @@ -0,0 +1,232 @@
>> +/*
>> + * Sonics Silicon Backplane
> 
> Err, this is for BCMA, not SSB =)
> 
> Thanks,
> 
Hi Julian,

Oh bad, I copied this file from ssb and modified it, but missed the
header. This is fixed now, but I should have a closer look at the
comments in general.

Hauke
