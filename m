Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:54686 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbYLPRN2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 12:13:28 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Memory errors from p54usb
Date: Tue, 16 Dec 2008 18:13:31 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
References: <49466F56.6060805@lwfinger.net> <200812161431.17790.chunkeey@web.de> <4947DD7A.9060700@lwfinger.net>
In-Reply-To: <4947DD7A.9060700@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812161813.31227.chunkeey@web.de> (sfid-20081216_181332_533191_E9C1D368)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 16 December 2008 17:55:22 Larry Finger wrote:
> It is in station mode. I don't know how to get the radio_enabled flag.
> > 
> > do you see anything else than probe request?
> 
> just probes.
does the AP answer the probe requests?
Is this with WPA-PSK TKIP on? what happens if you disable the
hardware crypto offload stuff (e.g p54common nohwcrypt=1 )

Regards,
	Chr
