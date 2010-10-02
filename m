Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36270 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0JBSsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 14:48:52 -0400
Received: by fxm14 with SMTP id 14so1161576fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 11:48:50 -0700 (PDT)
Subject: Re: Can 'iw' show the current tx-power?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CA76A91.9070200@candelatech.com>
References: <4CA6B6F9.8080104@candelatech.com>
	 <1286032902.11979.55.camel@maxim-laptop> <4CA76A91.9070200@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Oct 2010 20:48:47 +0200
Message-ID: <1286045327.11979.263.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-10-02 at 10:23 -0700, Ben Greear wrote:
> On 10/02/2010 08:21 AM, Maxim Levitsky wrote:
> > On Fri, 2010-10-01 at 21:37 -0700, Ben Greear wrote:
> >> It seems it can set it, but I don't see any command to print out
> >> the current value?
> >>
> >> Thanks,
> >> Ben
> >>
> > This is pretty much last missing feature from iw.
> 
> Maybe that and current operating transfer rate?  I can't
> seem to find that anywhere other than 'iwconfig'...

iw wlan0 link shows that.

Best regards,
	Maxim Levitsky

