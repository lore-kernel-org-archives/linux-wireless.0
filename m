Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:49106 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284AbZG0AGt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2009 20:06:49 -0400
Subject: Re: 2.6.31-rc2: Possible regression in rt61pci driver
From: Pavel Roskin <proski@gnu.org>
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <c6b1100b0907261433s5f069f8ck26861cef5239ef98@mail.gmail.com>
References: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com>
	 <c6b1100b0907140404h4fdbe419p8443da43350f3520@mail.gmail.com>
	 <c6b1100b0907210439jf67d886s3125dafa5f4d3928@mail.gmail.com>
	 <c6b1100b0907261215l71ada148y8a15f6595d939192@mail.gmail.com>
	 <1248639013.32168.15.camel@mj>
	 <c6b1100b0907261433s5f069f8ck26861cef5239ef98@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 26 Jul 2009 20:06:47 -0400
Message-Id: <1248653207.3106.9.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-07-26 at 22:33 +0100, Chris Clayton wrote:

> Do you have CONFIG_MAC80211_DEFAULT_PS enabled?

No.  That may explain everything.  I'll try enabling
CONFIG_MAC80211_DEFAULT_PS.

-- 
Regards,
Pavel Roskin
