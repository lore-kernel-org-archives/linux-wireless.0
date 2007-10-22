Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:28625 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbXJVQNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 12:13:49 -0400
Received: by ug-out-1314.google.com with SMTP id z38so932927ugc
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2007 09:13:48 -0700 (PDT)
Message-ID: <2cf3b3170710220913g75b6150fge0d265b34398ce71@mail.gmail.com> (sfid-20071022_171354_194573_AB953B71)
Date: Mon, 22 Oct 2007 17:13:46 +0100
From: "Robin Wood" <dninja@gmail.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Subject: Re: rtl8187 not being registered
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200710212125.34532.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <2cf3b3170710211433t253b6a8ck7d4c6d0913d5256b@mail.gmail.com>
	 <2cf3b3170710211435k36f17aaeqed5dba65718de21a@mail.gmail.com>
	 <200710212125.34532.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22/10/2007, Michael Wu <flamingice@sourmilk.net> wrote:
> On Sunday 21 October 2007 17:35:27 Robin Wood wrote:
> > I've just got the latest kernel source (2.6.23) from git and compiled
> > rtl8187 drivers as modules. When I plug the device in I get the
> > followoing:
> >
> > usb 1-3: new high speed USB device using ehci_hcd and address 3
> > usb 1-3: configuration #1 chosen from 1 choice
> > wmaster0: Failed to select rate control algorithm
> > wmaster0: Failed to initialize rate control algorithm
> > rtl8187: Cannot register device
> > rtl8187: probe of 1-3:1.0 failed with error -2
> >
> Make sure the rc80211_simple module can be found and is loaded.
>

Just to say thanks to Michael who helped sort the problem off list.
The problem was that I had module autoload disabled in the kernel.
After I'd enable that and after a quick rebuild and reboot all is now
working.

Robin
