Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:37226 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYLOXYc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 18:24:32 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
Date: Tue, 16 Dec 2008 00:24:27 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <494698AF.4020204@gmail.com> <4946BC0C.3040701@gmail.com> <4946E24E.1020504@gmail.com>
In-Reply-To: <4946E24E.1020504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812160024.27451.chunkeey@web.de> (sfid-20081216_002437_304385_CBA5AB9B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 16 December 2008 00:03:42 Artur Skawina wrote:
> Artur Skawina wrote:
> > Christian Lamparter wrote:
> >> On Monday 15 December 2008 19:41:13 Larry Finger wrote:
> >>> Artur Skawina wrote:
> >>>> I have a sinus 154 data usb adapter, which used to work w/ p54 in 2.6.27:
> >>> Can you bisect this problem?
> >> Naa I guess its "p54: fix memory management".

> Done:
> 78e74789bf2dab82f9539cd46e7f7583ff9516c1 is first bad commit
> commit 78e74789bf2dab82f9539cd46e7f7583ff9516c1
> Author: Christian Lamparter <chunkeey@web.de>
> Date:   Wed Oct 15 04:07:16 2008 +0200
> 
>     p54: fix memory management

ahh, well there went the 100% chance...

Anyway can you fire up usbmon
(see Linux-Source/Documentation/usb/usbmon.txt ,
or right there: http://www.mjmwired.net/kernel/Documentation/usb/usbmon.txt)
and capture the frames which are sent to the device?
for the p54usb in 2.6.27 and the not working one in the git tree?

Regards,
	Chr 
