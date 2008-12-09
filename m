Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n8a.bullet.ukl.yahoo.com ([217.146.183.156]:38684 "HELO
	n8a.bullet.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751487AbYLIEB4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 23:01:56 -0500
Message-ID: <493DEF32.5070403@yahoo.co.uk> (sfid-20081209_050200_541659_FB795370)
Date: Tue, 09 Dec 2008 04:08:18 +0000
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] rtl8187: Use usb anchor facilities to manage urbs
References: <493d9c06.XJn1gNkms3JqErgr%Larry.Finger@lwfinger.net>
In-Reply-To: <493d9c06.XJn1gNkms3JqErgr%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> When SLUB debugging is enabled in the kernel, and the boot command includes
> the option "slub_debug=P", rtl8187 encounters a GPF due to a read-after-free
> of a urb.
> 
> Following the example of changes in p54usb to fix the same problem, the code
> has been modified to use the usb_anchor_urb() method, which avoids the problem.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Just built it and using it right now.

Hin-Tak

