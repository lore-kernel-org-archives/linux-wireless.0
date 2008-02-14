Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:43096 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935096AbYBNBM2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 20:12:28 -0500
Subject: Re: Suggestions for USB Wi-Fi device
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <47B37DEF.3080107@lwfinger.net>
References: <47B37DEF.3080107@lwfinger.net>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 20:12:25 -0500
Message-Id: <1202951545.8941.53.camel@dv> (sfid-20080214_011245_312353_4E88B3F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-02-13 at 16:31 -0700, Larry Finger wrote:
> The motherboard on my notebook has failed so that my BCM9311 can no longer be accessed. The machine 
> is under warranty, but I will be moving around for the next two months and it will not be repaired 
> until April. In the interim, I am thinking about acquiring a USB wi-fi device. If you are using such 
> a device and it works out-of-the-box on Linux, please send me the make and model. If this model 
> comes with different chips, please tell me what I need.

Look for Level One WNC-0301USB.  There are several revisions, but I
checked the Windows drivers, and all appear to have corresponding Linux
drivers: rt73usb, rt2500usb, rtl8187 and zd1211rw.

My device is revision v3.  It's supported by rt73usb driver and works in
Fedora 8 out-of-box (at least with their updated current kernel).

-- 
Regards,
Pavel Roskin
