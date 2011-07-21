Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:58973 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab1GUXB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 19:01:27 -0400
Received: by pzk37 with SMTP id 37so2600511pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2011 16:01:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310835342-18877-2-git-send-email-hauke@hauke-m.de>
References: <1310835342-18877-1-git-send-email-hauke@hauke-m.de>
	<1310835342-18877-2-git-send-email-hauke@hauke-m.de>
Date: Fri, 22 Jul 2011 01:01:26 +0200
Message-ID: <CACna6rxugXiGd87hk_d5tK8NM0m9v_hjJ8o7xyQhkn=j9ocOJg@mail.gmail.com> (sfid-20110722_010235_219147_B6542DCF)
Subject: Re: [PATCH v2 01/11] bcma: move parsing of EEPROM into own function.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: ralf@linux-mips.org, linux-wireless@vger.kernel.org,
	linux-mips@linux-mips.org, jonas.gorski@gmail.com, mb@bu3sch.de,
	george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/16 Hauke Mehrtens <hauke@hauke-m.de>:
> Move the parsing of the EEPROM data in scan function for one core into
> an own function. Now we are able to use it in some other scan function
> as well.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Acked-by: Rafał Miłecki <zajec5@gmail.com>

-- 
Rafał
