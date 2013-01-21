Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35968
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756137Ab3AUUGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 15:06:13 -0500
Date: Mon, 21 Jan 2013 15:06:10 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Richard Farina <sidhayn@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [ANN] crda: v1.1.3
Message-ID: <20130121200610.GE1432@bombadil.infradead.org> (sfid-20130121_210615_687950_0E3B5815)
References: <E1TwInB-0003VY-Jh@sipsolutions.net>
 <50FA04B6.8080703@gmail.com>
 <CAB=NE6UHBZhg7L_Oh5EayLBQyY=fceqUBtfz=kEFXG_u2Ko9TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6UHBZhg7L_Oh5EayLBQyY=fceqUBtfz=kEFXG_u2Ko9TQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 21, 2013 at 12:05:05PM -0800, Luis R. Rodriguez wrote:
> Its just a warning but can you try adding the following path (in another e-mail)

This patch:

diff --git a/reglib.c b/reglib.c
index bc81974..1fafd37 100644
--- a/reglib.c
+++ b/reglib.c
@@ -9,6 +9,7 @@
 #include <fcntl.h>
 #include <stdbool.h>
 #include <unistd.h>
+#include <string.h>
 
 #include <arpa/inet.h> /* ntohl */
 
