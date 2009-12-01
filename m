Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:26951 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbZLAV6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 16:58:19 -0500
Received: by ey-out-2122.google.com with SMTP id 4so1310525eyf.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 13:58:25 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v3 3/4] rt2x00: Reorganize L2 padding inserting function.
Date: Tue, 1 Dec 2009 22:58:22 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>,
	John Linville <linville@tuxdriver.com>
References: <1259615298-2305-1-git-send-email-gwingerde@gmail.com> <1259615298-2305-3-git-send-email-gwingerde@gmail.com> <1259615298-2305-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259615298-2305-4-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912012258.23283.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 30 November 2009, Gertjan van Wingerde wrote:
> Simplify the rt2x00queue_insert_l2pad function by handling the alignment
> operations one by one. Do not special case special circumstances.
> Basically first perform header alignment, and then perform payload alignment
> (if any payload does exist). This results in a properly aligned skb.
> 
> The end result is better readable code, with better results, as now L2 padding
> is inserted only when a payload is actually present in the frame.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

