Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:36221 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbbHVC6d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2015 22:58:33 -0400
MIME-Version: 1.0
In-Reply-To: <b7e20f38636d48108be954343f45b63e@SC-EXCH02.marvell.com>
References: <b7e20f38636d48108be954343f45b63e@SC-EXCH02.marvell.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 22 Aug 2015 12:58:13 +1000
Message-ID: <CAGRGNgWrdwMQ+YX6aEZKgi5ZEPPhqtrWbv7zJij9JFdyp7gd-w@mail.gmail.com> (sfid-20150822_045836_661666_5CDE405C)
Subject: Re: [PATCH] Add FW binary used by mwlwifi driver.
To: David Lin <dlin@marvell.com>
Cc: "linux-firmware@vger.kernel.org" <linux-firmware@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

On Sat, Aug 22, 2015 at 12:37 PM, David Lin <dlin@marvell.com> wrote:
> Signed-off-by: David Lin <dlin@marvell.com>
> ---
>  mwlwifi/88W8864.bin | Bin 0 -> 116356 bytes
>  mwlwifi/88W8897.bin | Bin 0 -> 489084 bytes
>  2 files changed, 0 insertions(+), 0 deletions(-)
>  create mode 100755 mwlwifi/88W8864.bin
>  create mode 100755 mwlwifi/88W8897.bin

You _must_ provide a licence for those files and update the WHENCE
file as described in the README:
https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/tree/README

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
