Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a80-127-65-128.adsl.xs4all.nl ([80.127.65.128]:39805 "EHLO
	linux.wilsoft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZAFH5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 02:57:49 -0500
From: "W. van den Akker" <listsrv@wilsoft.nl>
To: linux-wireless@vger.kernel.org
Subject: Re: Still problems to get ath9k in accessmode. Kernel hangs
Date: Tue, 6 Jan 2009 08:57:41 +0100
References: <200901011444.20333.listsrv@wilsoft.nl> <20090105094102.GA27836@jm.kir.nu>
In-Reply-To: <20090105094102.GA27836@jm.kir.nu>
Cc: Jouni Malinen <j@w1.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901060857.41357.listsrv@wilsoft.nl> (sfid-20090106_085754_708489_23E0A11F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 05 January 2009, you wrote:
> On Thu, Jan 01, 2009 at 02:44:20PM +0100, W. van den Akker wrote:
> > I have tested on the server  with the latest wireless-testing the past
> > days (2.6.28-rc9-wl). The wireless-testing looks somewhat more stable
> > then the compat-wireless.
> >
> > I have also installed the netconsole module to watch any kernel prints.
> > After running hostapd (v0.6.6) from command line the AP is
> > up-and-running. Then if I connect with the laptop (tested it with kernel
> > .26 and .28 on the laptop) I get a connection and can start a browser en
> > explore the internet. If I start a second session (Kmail or second
> > browser) the
> > server hangs within a minute. Leaving again no trace on the console,
> > hostapd-log or netconsole.
>
> Just to make sure I understood this correctly.. Does this happen with
> just a single association station (your laptop)? What are you referring
> to with a "session"? Just another program using network (i.e., no new
> wireless associations, etc.)? As far as the ath9k driver is concerned,
> new applications (e.g., new TCP connection) should not really matter
> much.. If you have IEEE 802.11n enabled, could you please run a test
> with it disabled to make sure this is not related to frame aggregation?
>
> As far as getting any output from the system is concerned, the next step
> could be to see if NMI watchdog would be able to provide any help.
> Please take a look at Documentation/nmi_watchdog.txt in the kernel
> source code and see if you could use that on the AP to get some output
> when the system hangs (running without X on console to make sure you see
> the output).

Hi Jouni,

Yes you understood correctly. Only a laptop, start a browser then start Kmail 
over the same wireless connection. Then it hangs. This is always 
reproducable. There are also other sorts or hangups (for example when 
starting hostapd, but that is not always reproducable when it happens).

I will try today the watchdog-suggestion. Hope that it will provide some help.

To be continued....

gr,
Willem

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

