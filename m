Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:52486 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab0CAHeT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 02:34:19 -0500
Received: by mail-ew0-f220.google.com with SMTP id 20so1061584ewy.21
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2010 23:34:18 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: prahal@yahoo.com
Subject: Re: [PATCH] rt2x00: txdone implementation supporting hw encryption.
Date: Mon, 1 Mar 2010 08:34:16 +0100
Cc: John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <4B88490F.7030605@yahoo.com>
In-Reply-To: <4B88490F.7030605@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201003010834.17027.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 February 2010, Alban Browaeys wrote:
> This is an implementation that support WCID being the encryption key.
> Wireless Cli Id was set to be the encryption key in rt2800pci_write_tx_desc
> and read (TX_STA_FIFO_WCID) as the current queue entry index.
> 
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>


