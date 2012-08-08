Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50501 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758989Ab2HHRjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 13:39:51 -0400
Received: by vcbfk26 with SMTP id fk26so1014580vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 10:39:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50227EBF.9030400@lwfinger.net>
References: <CAEOSq-Nac1-6SbfQTLCO7bkQVWgLxZE4x0oNbviyyyToPZzo5w@mail.gmail.com>
	<50227EBF.9030400@lwfinger.net>
Date: Wed, 8 Aug 2012 10:39:50 -0700
Message-ID: <CAEOSq-MurTzp=KZsuPRxCipVioTfhmpMx2t6ZFMBvz-YDL4OcQ@mail.gmail.com> (sfid-20120808_193954_323012_E5682058)
Subject: Re: Problems with rtl8192cu driver in Access Point mode
From: Mike Thompson <mpthompson@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'll see what I can do to set up wireshark or kismit.  Also, as
suggested in the IRC forum I'm going to try to switch to debugging the
rtl8192cu driver on a PC where I'll have a lot more tools available to
analyze debug output from the driver.

I'll write back to this thread once I have more information what might
be happening to the ARP packets.

Thanks,

Mike Thompson

On Wed, Aug 8, 2012 at 7:59 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Do you have a 3rd system that can use wireshark or kismet to capture the
> data on the air? That way we would know if the ARP responses are being lost
> inside rtl8192cu, or if they are just being badly formatted and being
> rejected by the laptop's receiver.
>
> Larry
>
