Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:48586 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbYBNOfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 09:35:53 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: Suggestions for USB Wi-Fi device
Date: Thu, 14 Feb 2008 15:35:18 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <47B37DEF.3080107@lwfinger.net> <1202951545.8941.53.camel@dv>
In-Reply-To: <1202951545.8941.53.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200802141535.19085.mb@bu3sch.de> (sfid-20080214_143558_204258_80200021)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 14 February 2008 02:12:25 Pavel Roskin wrote:
> On Wed, 2008-02-13 at 16:31 -0700, Larry Finger wrote:
> > The motherboard on my notebook has failed so that my BCM9311 can no longer be accessed. The machine 
> > is under warranty, but I will be moving around for the next two months and it will not be repaired 
> > until April. In the interim, I am thinking about acquiring a USB wi-fi device. If you are using such 
> > a device and it works out-of-the-box on Linux, please send me the make and model. If this model 
> > comes with different chips, please tell me what I need.
> 
> Look for Level One WNC-0301USB.  There are several revisions, but I
> checked the Windows drivers, and all appear to have corresponding Linux
> drivers: rt73usb, rt2500usb, rtl8187 and zd1211rw.

If you don't need good monitor-mode capabilities, you can use a zd1211 device
like the Longshine LCS-8131G3.
It works pretty good in STA mode. Monitor mode is somewhat broken. It does
filter some MAC addresses in hardware.

-- 
Greetings Michael.
