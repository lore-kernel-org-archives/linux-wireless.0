Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:40733 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYJFGKW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 02:10:22 -0400
To: Pavel Roskin <proski@gnu.org>
Cc: Greg KH <greg@kroah.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: at76_usb driver status
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com>
	<20081005061603.GB28533@kroah.com> <87d4ifsgg5.fsf@litku.valot.fi>
	<1223270894.18180.7.camel@dv> <87vdw6mgdl.fsf@litku.valot.fi>
	<1223271737.18180.15.camel@dv>
From: Kalle Valo <Kalle.Valo@iki.fi>
Date: Mon, 06 Oct 2008 09:10:14 +0300
In-Reply-To: <1223271737.18180.15.camel@dv> (Pavel Roskin's message of "Mon\, 06 Oct 2008 01\:42\:17 -0400")
Message-ID: <87r66umeyh.fsf@litku.valot.fi> (sfid-20081006_081032_923590_8A48C3AB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@gnu.org> writes:

>> I agree, it's very confusing. I'll change the name of the mac80211
>> port to something else, most probably to at76c50x-usb. Any comments?
>> Anyone?
>
> I'd rather avoid the old driver completely.  But if we want to resurrect
> it, its name was "at76c503a".

The atmel driver says it supports that also that chipset:

config ATMEL
      tristate "Atmel at76c50x chipset  802.11b support"

Hence I would like to have the usb suffix in the name, just to avoid
the confusion.

-- 
Kalle Valo
