Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:65462 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbYJXJfe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 05:35:34 -0400
Received: by nf-out-0910.google.com with SMTP id d3so317367nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2008 02:35:33 -0700 (PDT)
Message-ID: <f6ca9fed0810240235h58902994ub6dbdd305c3c5253@mail.gmail.com> (sfid-20081024_113539_446579_693A9930)
Date: Fri, 24 Oct 2008 11:35:32 +0200
From: drago01 <drago01@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Best USB wireless interface with Linux?
Cc: "Carlo Nyto" <carlonyto@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890810231857m5262d975i7f67615362cde15b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <9d95d80e0810231803p6e753150w36fcd6d657613a27@mail.gmail.com>
	 <43e72e890810231857m5262d975i7f67615362cde15b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 24, 2008 at 3:57 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Oct 23, 2008 at 6:03 PM, Carlo Nyto <carlonyto@gmail.com> wrote:
>> I am looking to choose a USB wireless network interface that works
>> well under Linux.
>
> Atheros zd1211rw:
> http://wireless.kernel.org/en/users/Drivers/zd1211rw
>
> Atheros otus (802.11n, not upstream though):
>
> http://wireless.kernel.org/en/users/Drivers/otus
>
> * Intersil p54:
>
> http://wireless.kernel.org/en/users/Drivers/p54
>
> rndis_wlan:
>
> http://wireless.kernel.org/en/users/Drivers/rndis_wlan
>
> * Marvel usb -- no website
>
> I'll be inclined to support zd1211rw due to the amount of time its
> been in the kernel and the amount of wide testing it has received.
> Atheros 11n otus is the only 11n usb driver I'm aware of for Linux.

rt2800usb but afaik the driver is not in a working state yet. (the
vendor supplied one should work)
