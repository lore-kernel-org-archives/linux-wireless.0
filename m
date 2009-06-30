Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from b-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.35]:50596 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751882AbZF3S1A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 14:27:00 -0400
Date: Tue, 30 Jun 2009 08:25:34 -1000
From: Joel Roth <joelz@pobox.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k and Atheros AR242x - No scan results
Message-ID: <20090630182534.GA5758@sprite>
Reply-To: Joel Roth <joelz@pobox.com>
References: <20090630170916.GB5137@sprite>
 <43e72e890906301052l5a0b8984od8437fefa38e0dff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890906301052l5a0b8984od8437fefa38e0dff@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2009 at 10:52:09AM -0700, Luis R. Rodriguez wrote:
> On Tue, Jun 30, 2009 at 10:09 AM, Joel Roth<joelz@pobox.com> wrote:
> 
> sudo ip link set dev wlan0 up

Hi Luis,

I've tried this, with no obvious change.

I've not used the 'ip' command before in my networking
explorations, always relying on ifconfig to bring up
devices.

Ifconfig reports that wlan0 is UP. Is there any other
kind of UP that I need to understand?

Another question: From the point of view of setting up
wireless, if the wlan0 device is UP, should
'iwlist scan' return a list of access points? 

Or are there any other conditions to be met?

Thanks.

> 
> > $ iwlist wlan0 scan
> >
> > wlan0     No scan results
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Joel Roth
