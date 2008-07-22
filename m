Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:34801 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbYGVKqx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 06:46:53 -0400
Received: by fg-out-1718.google.com with SMTP id 19so835035fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 03:46:52 -0700 (PDT)
Date: Tue, 22 Jul 2008 10:51:58 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: David Miller <davem@davemloft.net>, kaber@trash.net, mingo@elte.hu,
	ischram@telenet.be, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
	at 0000000000000370
Message-ID: <20080722105158.GA6024@ff.dom.local> (sfid-20080722_124658_654768_0D42D216)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48857F74.2040406@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-07-2008 08:34, Larry Finger wrote:
...
>>> I used the davem patch, the second version of your first one, and 
>>> your second one. Both problems persist.

Could you send lockdep info after Patrick's "set lockdep classes"
patch?

Jarek P.
