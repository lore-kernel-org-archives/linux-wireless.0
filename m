Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57024 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758922AbYALWos (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2008 17:44:48 -0500
Message-ID: <478942DE.8060107@garzik.org> (sfid-20080112_224452_033966_DC6406E5)
Date: Sat, 12 Jan 2008 17:44:46 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Please pull 'fixes-jgarzik' branch of wireless-2.6 (use this
 one)
References: <20080110213034.GI3109@tuxdriver.com>
In-Reply-To: <20080110213034.GI3109@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> [2nd try -- turns-out the Mattis Nissler patch needed an extra tweak.
> It will probably also cause build breakage when you rebase since
> rt2x00lib_txdone(...) becomes rt2x00pci_txdone(rt2x00dev,...) in 2.6.25,
> so FYI... :-)
> 
> This also includes another patch (the "4 byte boundary" one) which
> is already in your upstream branch.  So, beware of that one too. :-)]
> 
> Jeff,
> 
> Three more fixes for 2.6.24.  The one from Mattias Nissler is already
> in your upstream tree...FYI.
> 
> Let me know if there are problems!
> 
> Thanks,
> 
> John
> 
> ---
> 
> Individual patches available here:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/fixes-jgarzik/
> 
> ---
> 
> The following changes since commit 3ce54450461bad18bbe1f9f5aa3ecd2f8e8d1235:
>   Linus Torvalds (1):
>         Linux 2.6.24-rc7
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git fixes-jgarzik
> 
> Ivo van Doorn (2):
>       rt2x00: Corectly initialize rt2500usb MAC
>       rt2x00: Put 802.11 data on 4 byte boundary
> 
> Mattias Nissler (1):
>       rt2x00: Allow rt61 to catch up after a missing tx report
> 
>  drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00pci.c |   20 ++++++++++++++++----
>  drivers/net/wireless/rt2x00/rt2x00usb.c |   17 +++++++++++++++--
>  drivers/net/wireless/rt2x00/rt61pci.c   |   12 ++++++++++++
>  4 files changed, 44 insertions(+), 7 deletions(-)

pulled


