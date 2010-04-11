Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:35311 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab0DKQ4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Apr 2010 12:56:48 -0400
Received: by ey-out-2122.google.com with SMTP id d26so386347eyd.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Apr 2010 09:56:45 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 6/9] rt2x00: Finish rt3070 support in rt2800 register initialization.
Date: Sun, 11 Apr 2010 18:56:44 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1270989075-2267-1-git-send-email-gwingerde@gmail.com> <1270989075-2267-7-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270989075-2267-7-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <201004111856.44400.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 11 April 2010, Gertjan van Wingerde wrote:
> rt2x00 had preliminary support for RT3070 based devices, but the support was
> incomplete.
> Update the RT3070 register initialization to be similar to the latest Ralink
> vendor driver.
> 
> With this patch my rt3070 based devices start showing a sign of life.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
