Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44708
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbXJFSJM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 14:09:12 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: usb wifi ad-hoc mode suggestions?
Date: Sat, 6 Oct 2007 20:08:37 +0200
Cc: Greg Johnson <gregfjohnson@yahoo.com>,
	linux-wireless@vger.kernel.org
References: <371947.67660.qm@web33501.mail.mud.yahoo.com> <4707CA7F.6030609@gentoo.org>
In-Reply-To: <4707CA7F.6030609@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710062008.37245.mb@bu3sch.de> (sfid-20071006_190928_096878_8074CFCD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 06 October 2007 19:48:47 Daniel Drake wrote:
> Greg Johnson wrote:
> > We're trying the zd1211 with the zd1211rw driver and the mac80211 stack,
> > which doesn't seem to have ad-hoc support currently, but their web site says
> > it should be easy to add.
> 
> If you have coding resources on your hands, all that needs to be done is 
> for someone to look at the ad-hoc handling code in the vendor driver and 
> port it over the mac80211 driver. Diving into the vendor driver is a bit 
> of a challenge though.

btw: Does the device also support AP mode?

-- 
Greetings Michael.
