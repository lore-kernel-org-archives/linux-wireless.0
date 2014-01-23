Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:43693 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbaAWArc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 19:47:32 -0500
Received: by mail-ob0-f176.google.com with SMTP id gq1so1311641obb.35
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 16:47:31 -0800 (PST)
Message-ID: <52E066A1.9010009@lwfinger.net> (sfid-20140123_014735_423125_685186BF)
Date: Wed, 22 Jan 2014 18:47:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Realtek 8821 wireless PCI driver?
References: <20140120193249.GA25707@kroah.com>
In-Reply-To: <20140120193249.GA25707@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2014 01:32 PM, Greg KH wrote:
> Hi all,
>
> I have a box here with a Realtek 8821 wireless PCI device.  We don't
> seem to have a driver upstream for it yet, but there's a huge tarball
> from Realtek on their site.
>
> Has anyone started picking the needed pieces out of the tarball to get
> this merged "properly", or does this need to be done yet?
>
> Hm, I wonder if I should just dump the tarball into staging for now, to
> get my box working, any objections to me doing that?

I have had contact with the Realtek developers regarding a Linux driver for the 
RTL8821AE device with PCI ID 10ec:8821. On Dec 10, 2013, they indicated that 
there were still 802.11ac problems, and they were not yet ready to release it to 
me. I will write them again and check if the driver is now ready, and they just 
forgot to send it to me. Once they are ready, they will also be sending me 
sample devices.

What is the URL for the driver that you found? I did a quick search on their 
site and did not find it.

To answer your question, I certainly would have no objections to your dumping 
the driver into staging. I can fix it up there as easily as in my own private 
stores. You will, of course, get a lot more intermediate patches, but I think 
you have already anticipated that. The PCI group usually send me mac80211-based 
drivers, thus the residence in staging may be short, but that is desirable.

Larry




