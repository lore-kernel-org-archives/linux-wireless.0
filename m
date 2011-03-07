Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34702 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1CGQmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 11:42:18 -0500
Received: by bwz15 with SMTP id 15so3891802bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Mar 2011 08:42:17 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] p54spi: Update kconfig help text
Date: Mon, 7 Mar 2011 17:42:08 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1299501084.5665.13.camel@marge>
In-Reply-To: <1299501084.5665.13.camel@marge>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201103071742.09073.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 March 2011 13:31:24 Michael Buesch wrote:
> This updates the p54spi Kconfig help text.
> The driver works well on n8x0, so remove the words "experimental" and "untested".
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
ACK, we'll take your word of it.
Any news about the power save issue?
Was it "fixed" by a recent commit or is it no
longer a problem? 

Regards,
	Chr
