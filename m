Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42528 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab0HWOiV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:38:21 -0400
Subject: Re: iwlagn fails to associate on 2.6.36-rc2
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100823141432.GA29902@infradead.org>
References: <20100823110247.GA3198@infradead.org>
	 <1282572681.20674.3.camel@wwguy-ubuntu>
	 <20100823141432.GA29902@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Aug 2010 07:42:13 -0700
Message-ID: <1282574533.12500.1.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-23 at 07:14 -0700, Christoph Hellwig wrote:
> On Mon, Aug 23, 2010 at 07:11:21AM -0700, Guy, Wey-Yi wrote:
> > it is kind of strange, the connection can stay if you have background
> > ping going?
> 
> Yes (that's on a kernel up to 2.6.35). Otherwise it drops a lot, up
> to ca 2.6.32 it kept working.  See the linux-wireless archives for my
> report from back then.
> 
> > could you give more description on your problem, band/channel/...
> > you also can turn on the debug flag debug=0x43fff to capture the current
> > status of iwlwifi. it do require you compile kernel with full debugging
> > support.
> 
> I don't know what you mean with full kernel debugging.  iwlagn
> debugging, mac80211 debugging?  Just tell me the options and I'll run
> with it.

Turn both iwlagn anf mac80211 debugging on when you compile kernel and
use debug=0x43fff when you load the iwlagn module

Thanks
Wey

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


