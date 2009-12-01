Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34812 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbZLAV63 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 16:58:29 -0500
Received: by ewy19 with SMTP id 19so5458123ewy.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 13:58:34 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v3 4/4] rt2x00: Only remove L2 padding in received frames if there is payload.
Date: Tue, 1 Dec 2009 22:58:32 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>,
	John Linville <linville@tuxdriver.com>
References: <1259615298-2305-1-git-send-email-gwingerde@gmail.com> <1259615298-2305-4-git-send-email-gwingerde@gmail.com> <1259615298-2305-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259615298-2305-5-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912012258.33123.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 30 November 2009, Gertjan van Wingerde wrote:
> L2 padding will only be present when there is actual payload present.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
