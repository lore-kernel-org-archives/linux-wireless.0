Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46843 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901AbZKDThB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 14:37:01 -0500
Subject: Re: [PATCH] libertas if_usb: Fix crash on 64-bit machines
From: David Woodhouse <dwmw2@infradead.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	dcbw@redhat.com, stern@rowland.harvard.edu, davem@davemloft.net
In-Reply-To: <20091104191642.GB10786@tuxdriver.com>
References: <1256924714.4030.44.camel@macbook.infradead.org>
	 <200910301944.14740.chunkeey@googlemail.com>
	 <1256928681.4030.112.camel@macbook.infradead.org>
	 <200910302026.47131.chunkeey@googlemail.com>
	 <20091104191642.GB10786@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Nov 2009 19:36:58 +0000
Message-ID: <1257363418.22822.28.camel@macbook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-11-04 at 14:16 -0500, John W. Linville wrote:
> Is anyone evaluating these suggestions?  Should I be expecting
> properly formatted patch emails? 

The suggestions make sense, but not for stable. Let's fix the crasher
bug first, and worry about the rest later.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

