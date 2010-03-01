Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:52486 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab0CAHeg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 02:34:36 -0500
Received: by mail-ew0-f220.google.com with SMTP id 20so1061584ewy.21
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2010 23:34:36 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: prahal@yahoo.com
Subject: Re: [PATCH] rt2x00: Fix TX status reporting for rt2800pci.
Date: Mon, 1 Mar 2010 08:34:34 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Josef Bacik <josef@redhat.com>
References: <4B8A9670.1080906@yahoo.com>
In-Reply-To: <4B8A9670.1080906@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201003010834.34740.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 28 February 2010, Alban Browaeys wrote:
> After testing, we found that TX_STA_FIFO_MCS is the last MCS value
> tried. If the transmission failed, 8 frames have been transmitted. If the
> transmission succeed, we can easily compute the number of retry.  This patch fix
> the way status is reported to mac80211 rate control. It has 2 bugs :
> 
> 1. mcs can contain the short preamble flag and it will lead to wrong
> computations.
> 
> 2. minstrel nearly always say that 54 Mbits is the best rate, even if we are
> very far from the AP
> 
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

