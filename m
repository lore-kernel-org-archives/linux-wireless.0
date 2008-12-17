Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:44793 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbYLQOUk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 09:20:40 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Memory errors from p54usb
Date: Wed, 17 Dec 2008 15:20:40 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
References: <49466F56.6060805@lwfinger.net> <200812162256.36605.chunkeey@web.de> <49487038.5090404@lwfinger.net>
In-Reply-To: <49487038.5090404@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812171520.40104.chunkeey@web.de> (sfid-20081217_152045_019858_48FD6542)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 17 December 2008 04:21:28 Larry Finger wrote:
> Christian Lamparter wrote:
> > well, looks like TKIP countermeasures after all....
> > 
> > The question is how to "debug" it...
> > 
> > jm, are you aware of any compatibility problems or
> > regression between broadcom APs and wpa_supplicant
> > with WPA TKIP?
> 
> Unfortunately (?) the problem still occurs with an unencrypted network. I hauled
> out my 801.11b AP/router, and the same problem occurs even when wpa_supplicant
> is not in the equation.
> 
Ohh, it always gets better. ;)
Anyway, I'll see what I can do tomorrow. 

In the meantime, I remembered that I put a heat sink on my chip a while ago,
but I'm not sure if this had any effect here... But back in the summer, it allowed me
fix the iperf stalls I had, but that was after days with 60Gb traffic...

Regards,
	Chr
