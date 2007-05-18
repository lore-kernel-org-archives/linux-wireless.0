Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43972 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbXERXFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 19:05:51 -0400
Date: Sat, 19 May 2007 00:04:45 +0100
From: Christoph Hellwig <hch@infradead.org>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: Jeff Garzik <jeff@garzik.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
Message-ID: <20070518230445.GA29062@infradead.org>
References: <464B7B7C.5080800@linux.intel.com> <20070516203505.556df4f9.randy.dunlap@oracle.com> <464E0DB5.5010802@linux.intel.com> <464E233A.6060209@garzik.org> <464E1B4A.8050105@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <464E1B4A.8050105@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 18, 2007 at 02:31:54PM -0700, James Ketrenos wrote:
> Alright; I'll add replacing the bitfields with bitwise access to the todo 
> list.
> 
> Are you OK with us marking the driver as not working on big endian for now 
> and getting this one fixed over time?

Given that Intel still hasn't fixed the older ipw2X00 drivers for big
endian despite clong-time onstant prodding I'm dead set against this.
It just won't happen if you don't do it now.

