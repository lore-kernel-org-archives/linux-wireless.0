Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from usul.saidi.cx ([204.11.33.34]:59756 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752240AbYHTDCj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 23:02:39 -0400
Message-ID: <48AB8941.4080209@overt.org> (sfid-20080820_050243_100169_8FAF0F30)
Date: Tue, 19 Aug 2008 20:02:25 -0700
From: Philip Langdale <philipl@overt.org>
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: LKML <linux-kernel@vger.kernel.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
 through rfkill (v5)
References: <48A728B0.8030206@overt.org> <20080820012936.GE29336@khazad-dum.debian.net>
In-Reply-To: <20080820012936.GE29336@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
>> +		toshiba_acpi.rfk_dev->state = RFKILL_STATE_OFF;
> 
> Where did that RFKILL_STATE_OFF came from ? :-)  Just get rid of it, you
> override it four statements later anyway...

Left over from the first iteration. Now removed and diff updated.

> 
> Other than that, the rfkill bits look fine to me.
> 

Thanks. Anyone else care to voice an opinion? Should this go in through
wireless-testing then?

--phil
