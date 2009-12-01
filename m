Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41331 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbZLATVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 14:21:35 -0500
Received: by ewy19 with SMTP id 19so5291420ewy.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 11:21:40 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Benoit Papillault <benoit.papillault@free.fr>
Subject: Re: [PATCH 2/2] rt2x00: Fix rt2800usb RX frame format and as such L2PAD
Date: Tue, 1 Dec 2009 20:21:38 +0100
Cc: gwingerde@gmail.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com,
	John Linville <linville@tuxdriver.com>
References: <1259619690-2749-1-git-send-email-benoit.papillault@free.fr> <1259619690-2749-2-git-send-email-benoit.papillault@free.fr>
In-Reply-To: <1259619690-2749-2-git-send-email-benoit.papillault@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912012021.38915.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 30 November 2009, Benoit Papillault wrote:
> According to Ralink source code, the RX frame format is RXINFO + RXWI +
> 802.11 frame + RXD, including various padding. Before this patch, we
> were using RXD + RXWI + 802.11 frame, so RXD was not correct.
> 
> Doing this, we fix the L2PAD bit which is now correctly set on received
> frames.
> 
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
