Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757998AbZKDUCf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 15:02:35 -0500
Subject: Re: [PATCH] libertas if_usb: Fix crash on 64-bit machines
From: Dan Williams <dcbw@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	stern@rowland.harvard.edu, davem@davemloft.net
In-Reply-To: <1257363418.22822.28.camel@macbook.infradead.org>
References: <1256924714.4030.44.camel@macbook.infradead.org>
	 <200910301944.14740.chunkeey@googlemail.com>
	 <1256928681.4030.112.camel@macbook.infradead.org>
	 <200910302026.47131.chunkeey@googlemail.com>
	 <20091104191642.GB10786@tuxdriver.com>
	 <1257363418.22822.28.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Wed, 04 Nov 2009 12:01:43 -0800
Message-Id: <1257364903.14545.51.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-11-04 at 19:36 +0000, David Woodhouse wrote:
> On Wed, 2009-11-04 at 14:16 -0500, John W. Linville wrote:
> > Is anyone evaluating these suggestions?  Should I be expecting
> > properly formatted patch emails? 
> 
> The suggestions make sense, but not for stable. Let's fix the crasher
> bug first, and worry about the rest later.

Sounds good to me...

Dan


