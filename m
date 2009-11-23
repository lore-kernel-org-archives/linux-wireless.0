Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59081 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbZKWSMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 13:12:37 -0500
Received: by ewy19 with SMTP id 19so2118321ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 10:12:42 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 2/6] rt2x00: Remove unused variable frame_control from rt2x00mac_tx.
Date: Mon, 23 Nov 2009 19:12:39 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <1258960565-26736-1-git-send-email-gwingerde@gmail.com> <1258960565-26736-2-git-send-email-gwingerde@gmail.com> <1258960565-26736-3-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1258960565-26736-3-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911231912.40056.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 November 2009, Gertjan van Wingerde wrote:
> As additional fallout also remove the also unused variable ieee80211hdr.
> 
> Reported-by: Johannes Stezenbach <js@sig21.net>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
