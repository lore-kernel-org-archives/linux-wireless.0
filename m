Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:53059 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbYLQDVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 22:21:34 -0500
Message-ID: <49487038.5090404@lwfinger.net> (sfid-20081217_042143_259532_8470345B)
Date: Tue, 16 Dec 2008 21:21:28 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>, Jouni Malinen <j@w1.fi>
Subject: Re: Memory errors from p54usb
References: <49466F56.6060805@lwfinger.net> <200812162029.22491.chunkeey@web.de> <49481CCC.1030903@lwfinger.net> <200812162256.36605.chunkeey@web.de>
In-Reply-To: <200812162256.36605.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> well, looks like TKIP countermeasures after all....
> 
> The question is how to "debug" it...
> 
> jm, are you aware of any compatibility problems or
> regression between broadcom APs and wpa_supplicant
> with WPA TKIP?

Unfortunately (?) the problem still occurs with an unencrypted network. I hauled
out my 801.11b AP/router, and the same problem occurs even when wpa_supplicant
is not in the equation.

Larry
