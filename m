Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:19001 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbZF3WmM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 18:42:12 -0400
Subject: Re: [PATCH 4/5] Introduce separate HOST and TARGET compilation
 steps.
From: Pavel Roskin <proski@gnu.org>
To: Jon Loeliger <jdl@bigfootnetworks.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1246396772.13176.264.camel@jdl-desktop>
References: <1246396772.13176.264.camel@jdl-desktop>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 18:42:13 -0400
Message-Id: <1246401733.31826.26.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-06-30 at 16:19 -0500, Jon Loeliger wrote:

> +TARGET_CFLAGS += -Wall -g

That's a misleading name.  There is nothing wrong with using CFLAGS for
compilation.

"target" normally refers to the system for which the program being
compiled would create or manipulate binaries.  CRDA doesn't manipulate
system-dependent binaries.  It's not a compiler or an assembler.  It
works with a system-independent database.

-- 
Regards,
Pavel Roskin
