Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:38286 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYIVUF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 16:05:28 -0400
From: Chr <chunkeey@web.de>
To: "Philippe Waroquiers" <philippe.waroquiers@skynet.be>
Subject: Re: prism54 stopped working after upgrade from kernel 2.6.25.14-69.fc8 to 2.6.26.3-14.fc8
Date: Mon, 22 Sep 2008 22:05:28 +0200
Cc: linux-wireless@vger.kernel.org
References: <CB9B2237C21D46F3B852E45F75E91C52@soleil>
In-Reply-To: <CB9B2237C21D46F3B852E45F75E91C52@soleil>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809222205.28754.chunkeey@web.de> (sfid-20080922_220531_611766_4C6017EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 September 2008 20:38:04 Philippe Waroquiers wrote:
> With the new kernel 2.6.26.3-14.fc8, I see that the prism54 card looks in a
> correct working mode (e.g. /sbin/iwlist wlan0 scan shows good scan
> results).
> But after that, wpa_supplicant cannot associate (gets a timeout)
> (while it works ok with 2.6.25.14-69.fc8)
> I have put below the output of wpa_supplicant for the bad case
> and for the good case.
>
> What can I do to further see what is going wrong ?
>

Well, you can blame the fedora people if you want.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=aaa1553512b9105699113ea7e2ea726f3d9d4de2

Regards,
	Chr
