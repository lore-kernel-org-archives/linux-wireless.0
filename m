Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43963 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab0EFK43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 06:56:29 -0400
Received: by fxm10 with SMTP id 10so5000849fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 03:56:27 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 2/3] rt2x00: rt2800: don't overwrite SIFS values on erp changes
Date: Thu, 6 May 2010 12:56:15 +0200
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201005061229.44923.helmut.schaa@googlemail.com> <201005061251.09142.helmut.schaa@googlemail.com>
In-Reply-To: <201005061251.09142.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005061256.15682.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 06 Mai 2010 schrieb Helmut Schaa:
> Nevertheless I don't get good transfer speeds. I didn't measure exactly but
> just with scp. And I got ~600-700 KByte/s for TX and 400-500KByte/s for RX.
> This is still quite low.

Nevermind, tested on a MIPS board. So maybe it's not the wireless but the CPU
that's limiting scp performance.

When I find some time I'll try plain TCP connections.

Helmut
