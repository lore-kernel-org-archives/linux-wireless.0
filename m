Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62359 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbbGXLEM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 07:04:12 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Andreas Fenkart <afenkart@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>
Subject: RE: [PATCH 0/4] refactor cmd_node recycling
Date: Fri, 24 Jul 2015 11:04:06 +0000
Message-ID: <0de96af6690b4e388b23b2a6636627f8@SC-EXCH04.marvell.com> (sfid-20150724_130416_370614_882DFF25)
References: <1437117186-25243-1-git-send-email-afenkart@gmail.com>
In-Reply-To: <1437117186-25243-1-git-send-email-afenkart@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

> From: Andreas Fenkart [mailto:afenkart@gmail.com]
> Sent: Friday, July 17, 2015 12:43 PM
> To: linux-wireless@vger.kernel.org
> Cc: Amitkumar Karwar; Kalle Valo; Andreas Fenkart
> Subject: [PATCH 0/4] refactor cmd_node recycling
> 
> Following patches are trying to simplify the code paths used to recycle
> processed commands
> 
> Andreas Fenkart (4):
>   mwifiex: remove explicit mwifiex_complete_cmd calls
>   mwifiex: remove redundant reset of cmd_wait_q status
>   mwifiex: remove CMD_F_CANCELED flag
>   mwifiex: simplify mwifiex_complete_cmd
> 
>  drivers/net/wireless/mwifiex/cmdevt.c    | 35 +++++++++++--------------
> -------
>  drivers/net/wireless/mwifiex/fw.h        |  1 -
>  drivers/net/wireless/mwifiex/sta_ioctl.c |  4 ++--
>  drivers/net/wireless/mwifiex/util.c      | 12 ++++-------
>  4 files changed, 18 insertions(+), 34 deletions(-)
> 

Looks fine to me. Thanks for the cleanup work and simplifying the command path.

Regards,
Amitkumar
