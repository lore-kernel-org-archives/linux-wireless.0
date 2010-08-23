Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6817 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab0HWRBU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 13:01:20 -0400
Subject: Re: iwlagn fails to associate on 2.6.36-rc2
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100823163259.GA15511@infradead.org>
References: <20100823110247.GA3198@infradead.org>
	 <1282572681.20674.3.camel@wwguy-ubuntu>
	 <20100823141432.GA29902@infradead.org>
	 <1282574533.12500.1.camel@wwguy-huron>
	 <20100823163259.GA15511@infradead.org>
Content-Type: text/plain
Date: Mon, 23 Aug 2010 10:00:45 -0700
Message-Id: <1282582845.13288.4.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-23 at 09:32 -0700, Christoph Hellwig wrote:
> On Mon, Aug 23, 2010 at 07:42:13AM -0700, Guy, Wey-Yi wrote:
> > Turn both iwlagn anf mac80211 debugging on when you compile kernel and
> > use debug=0x43fff when you load the iwlagn module
> 
> Here's a log for the sequence of:
> 
> 	modprobe iwlagn debug=0x43fff
> 	ifup wlan0
> 
> until dhclient times out.

Hi Christoph,

there is a important RTS/CTS patch
94597ab23ea10b3bdcba534be00a9f7b35791c07

http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=commit;h=94597ab23ea10b3bdcba534be00a9f7b35791c07


please apply and try

Thanks
Wey


