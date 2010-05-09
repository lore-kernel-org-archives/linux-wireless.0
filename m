Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56983 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab0EIJLn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 May 2010 05:11:43 -0400
Received: by bwz19 with SMTP id 19so1241385bwz.21
        for <linux-wireless@vger.kernel.org>; Sun, 09 May 2010 02:11:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273354826-4335-7-git-send-email-gwingerde@gmail.com>
References: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
	 <1273354826-4335-7-git-send-email-gwingerde@gmail.com>
Date: Sun, 9 May 2010 11:11:41 +0200
Message-ID: <AANLkTily3wy_5olyc8_kz8dZWTQBDO8mbJLuIfYYuBjc@mail.gmail.com>
Subject: Re: [PATCH 6/9] rt2x00: Clean up generic procedures on descriptor
	writing.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 8, 2010 at 11:40 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> With a little bit of restructuring it isn't necessary to have special
> cases in rt2x00queue_write_tx_descriptor for writing the descriptor
> for beacons.
> Simply split off the kicking of the TX queue to a separate function
> with is only called for non-beacons.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
