Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38728 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbaHET6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2014 15:58:12 -0400
Date: Tue, 5 Aug 2014 15:08:20 -0400
From: Kyle McMartin <kyle@infradead.org>
To: "Machani, Yaniv" <yanivma@ti.com>
Cc: "ben@decadent.org.uk" <ben@decadent.org.uk>,
	"linux-firmware@kernel.org" <linux-firmware@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-firmware: pull-request TI wireless firmware
Message-ID: <20140805190820.GI18548@merlin.infradead.org> (sfid-20140805_215815_942808_2C784B08)
References: <AE1C82FB3D0EC64DB1F752C81CBD1101263A0EBB@DFRE01.ent.ti.com>
 <AE1C82FB3D0EC64DB1F752C81CBD1101263A3980@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AE1C82FB3D0EC64DB1F752C81CBD1101263A3980@DFRE01.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 13, 2014 at 02:16:14PM +0000, Machani, Yaniv wrote:
> Hi,
> Please see below pull request,
> It contains an update to the WiLink8 chip.
> The FW name was changed due to some new API's that was introduced lately.
> 

I've applied this. Thanks!

regards, Kyle

> Best Regards,
> Yaniv
> 
> 
> The following changes since commit 7f388b4885cf64d6b7833612052d20d4197af96f:
> 
>   Move the s5p-mfc firmware out of its subdirectory (2014-06-04 13:14:13 +0100)
> 
> are available in the git repository at:
> 
>   git://git.ti.com/wilink8-wlan/linux-firmware.git master
> 
> for you to fetch changes up to cbf9f8f506ad6a46818fa61af461aa615fdd4e87:
> 
>   wl18xx: add version 4 of the wl18xx firmware (2014-07-10 15:01:58 +0300)
> 
> ----------------------------------------------------------------
> Yaniv Machani (1):
>       wl18xx: add version 4 of the wl18xx firmware
> 
>  WHENCE                          |    2 ++
>  ti-connectivity/wl18xx-fw-4.bin |  Bin 0 -> 681704 bytes
>  2 files changed, 2 insertions(+), 0 deletions(-)  create mode 100755 ti-connectivity/wl18xx-fw-4.bin
> 
> diff --git a/WHENCE b/WHENCE
> index a172f5f..f8ab2fb 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1867,6 +1867,8 @@ File: ti-connectivity/wl18xx-fw-2.bin
>  Version: 8.5.0.0.55
>  File: ti-connectivity/wl18xx-fw-3.bin
>  Version: 8.8.0.0.13
> +File: ti-connectivity/wl18xx-fw-4.bin
> +Version: 8.9.0.0.17
>  File: ti-connectivity/wl18xx-conf.bin
>  Version: 6/5
>  
> diff --git a/ti-connectivity/wl18xx-fw-4.bin b/ti-connectivity/wl18xx-fw-4.bin new file mode 100755 index 0000000..8369a9e Binary files /dev/null and b/ti-connectivity/wl18xx-fw-4.bin differ
>  
> 
