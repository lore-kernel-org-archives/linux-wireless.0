Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:48770 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758577Ab0DWSCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 14:02:05 -0400
Received: by ewy20 with SMTP id 20so3162732ewy.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Apr 2010 11:02:02 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH] rt2x00: rt2800: use tx_power2 in rt2800_config_channel_rf3xxx
Date: Fri, 23 Apr 2010 20:01:59 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
References: <201004231554.43474.helmut.schaa@googlemail.com>
In-Reply-To: <201004231554.43474.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201004232002.00273.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 April 2010, Helmut Schaa wrote:
> Get closer to what the ralink driver does by setting the rf register 13
> to tx_power2 during channel switch.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
