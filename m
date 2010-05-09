Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33029 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0EIJQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 May 2010 05:16:26 -0400
Received: by bwz19 with SMTP id 19so1242425bwz.21
        for <linux-wireless@vger.kernel.org>; Sun, 09 May 2010 02:16:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273354826-4335-8-git-send-email-gwingerde@gmail.com>
References: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
	 <1273354826-4335-8-git-send-email-gwingerde@gmail.com>
Date: Sun, 9 May 2010 11:16:24 +0200
Message-ID: <AANLkTimcu7QfVV_iVlpjMR--ywETZaQFhTwurT7IASqV@mail.gmail.com>
Subject: Re: [PATCH 7/9] rt2x00: Clean up all driver's kick_tx_queue callback
	functions.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 8, 2010 at 11:40 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> All of the driver's kick_tx_queue callback functions treat the TX queue
> for beacons in a special manner.
> Clean this up by integrating the kicking of the beacon queue into the
> write_beacon callback function, and let the generic code no longer call
> the kick_tx_queue callback function when updating the beacon.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
