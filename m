Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:39849 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbZBBWkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 17:40:35 -0500
Message-ID: <49877655.8020408@lwfinger.net> (sfid-20090202_234041_146404_1E285C7A)
Date: Mon, 02 Feb 2009 16:40:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hans Ekbrand <hans@sociologi.cjb.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: USB 1.1, usb-dongle, NETGEAR WG111v2, timing problems in	association
References: <20090117204654.GB9079@amin> <4972B25B.7070306@lwfinger.net> <20090202155542.GE24485@samir> <498719F3.4070601@lwfinger.net> <20090202190255.GF24485@samir>
In-Reply-To: <20090202190255.GF24485@samir>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hans Ekbrand wrote:
> 
> Did it work on USB 1.1 even without your enhancements?
> 

Yes. Almost nothing I changed dealt with the USB interface - just with
the TX part of the code. The part that did affect USB fixed a stalling
problem on both 1.1 and 2.0.

Larry


