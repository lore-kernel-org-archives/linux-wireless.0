Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:54136 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbZKHOih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 09:38:37 -0500
Received: by ewy3 with SMTP id 3so2398166ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 06:38:41 -0800 (PST)
Message-ID: <4AF6D7EF.60405@gmail.com>
Date: Sun, 08 Nov 2009 15:38:39 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/9] rt2800: add eFuse EEPROM support code to rt2800lib
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain> <20091108133948.23584.12804.sendpatchset@localhost.localdomain>
In-Reply-To: <20091108133948.23584.12804.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/09 14:39, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800: add eFuse EEPROM support code to rt2800lib
> 
> eFuse EEPROM is used also by USB chips (i.e. RT3070)
> so move the needed code from rt2800pci to rt2800lib.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
