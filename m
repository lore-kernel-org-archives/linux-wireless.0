Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab3CUSll (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 14:41:41 -0400
Message-ID: <1363891343.6412.19.camel@dcbw.foobar.com> (sfid-20130321_194145_250409_C32EA4B9)
Subject: Re: Support for Realtek USB PID 0bda:1724 (rtl8723a?)
From: Dan Williams <dcbw@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 21 Mar 2013 13:42:23 -0500
In-Reply-To: <514B5113.3030501@lwfinger.net>
References: <1363889497.6412.18.camel@dcbw.foobar.com>
	 <514B5113.3030501@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-21 at 13:27 -0500, Larry Finger wrote:
> On 03/21/2013 01:11 PM, Dan Williams wrote:
> > Hi,
> >
> > I've gotten a few questions about this device and wondered if support
> > for this is feasible; it's not in any of the rtlwifi vid/pid lists yet.
> >
> > Some Internet Thread says there's a vendor driver here:
> >
> > http://dl.dropbox.com/u/57056576/DRIVERS/REALTEK/rtl_92ce_92se_92de_8723ae_linux_mac80211_0006.0514.2012.tar.gz
> >
> > but I failed to find the USB IDs for that device in here.
> 
> That driver is for the RTL8723AE, and other PCI-based devices. There is no USB 
> code in it.
> 
> I personally have never seen an RTL8723AU, which would be the proper designation 
> for a USB device with the 8723A chip.
> 
> Do you have a link as to what devices have this chip? I am interested in adding 
> it to my collection, and getting a driver for it into the kernel.

Lenovo IdeaPad Yoga 13; I've got people that would be interested in
trying out fixes.

Dan

