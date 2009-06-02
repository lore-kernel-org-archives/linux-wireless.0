Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50218 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758285AbZFBHmZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 03:42:25 -0400
Subject: Re: [Announce] Intel Wireless Multicomm 3200 WiFi driver
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890906011600s3290e579q5e2d3400ec609099@mail.gmail.com>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
	 <20090526222433.GA23972@bombadil.infradead.org>
	 <1243736227.3623.180.camel@debian>
	 <43e72e890905302327x23d0479bkb825ea05832c5ffd@mail.gmail.com>
	 <1243752126.3623.375.camel@debian>
	 <43e72e890906011600s3290e579q5e2d3400ec609099@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 15:42:19 +0800
Message-Id: <1243928539.5799.8.camel@joice>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-06-02 at 00:00 +0100, Luis R. Rodriguez wrote:
> On Sat, May 30, 2009 at 11:42 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> > On Sun, 2009-05-31 at 14:27 +0800, Luis R. Rodriguez wrote:
> >>
> >> What is the 11n configuration on these devices? Do they have 2
> >> streams? Or are they just 1 stream?
> >
> > It has 1x1, 1x2 and 2x2 on for both 20MHz and 40MHz channels.
> 
> Thanks -- BTW so this to me reads as number of TX/RX chains, but how
> many streams does the device have? For example a 2-stream device can
> be used in a 1x1 configuration.
> 
> An example of our 1-stream device would be the Atheros AR9285, so
> hardware-wise it only supports up to MCS 7.
> 
> Will some of these devices be 1-stream or are they all 2-stream?

The one I have should be a 2 streams one. What does 1 stream version buy
if we have already built the 2 streams (configurable for 1x1) version?

Thanks,
-yi

