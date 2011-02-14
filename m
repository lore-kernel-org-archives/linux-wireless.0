Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:42940
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753317Ab1BNMNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 07:13:08 -0500
Message-ID: <4D591AF7.8030301@freedesktop.org>
Date: Mon, 14 Feb 2011 07:07:19 -0500
From: Jim Gettys <jg@freedesktop.org>
MIME-Version: 1.0
To: bloat@lists.bufferbloat.net, linux-wireless@vger.kernel.org
Subject: Fwd: dynamic wi-fi buffer sizing paper
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Van Jacobson pointed out the following paper and implementation about 
802.11 buffer sizing.

See:

http://www.hamilton.ie/tianji_li/
http://www.hamilton.ie/tianji_li/buffersizing.pdf

If I can ever get a final version of "RED in a different light" out of 
Van I'll forward a pointer to the list...
			- Jim


-------- Original Message --------
Subject: dynamic wi-fi buffer sizing paper
Date: Thu, 6 Jan 2011 10:50:12 PST
From: Van Jacobson <van@parc.com>
To: Jim Gettys <jg@freedesktop.org>

Jim,

Here's the Doug Leith paper I mentioned. As I said on the phone I
think there's an easier, more robust way to accomplish the same
thing but they have running code and I don't. You can get their
mad-wifi implementation at
http://www.hamilton.ie/tianji_li/buffersizing.html

  - van

