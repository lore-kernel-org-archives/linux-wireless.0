Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:32905 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbXEUVXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2007 17:23:18 -0400
Date: Mon, 21 May 2007 23:22:09 +0200
From: Joerg Mayer <jmayer@loplof.de>
To: "Cohen, Guy" <guy.cohen@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	James Ketrenos <jketreno@linux.intel.com>,
	Jeff Garzik <jeff@garzik.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
Message-ID: <20070521212209.GX1955@thot.informatik.uni-kl.de>
References: <20070521181543.GA838@infradead.org> <D0122E209EBF8D4CAB38EC6A8AF244E5028B1C2D@hasmsx412.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <D0122E209EBF8D4CAB38EC6A8AF244E5028B1C2D@hasmsx412.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 21, 2007 at 11:12:17PM +0300, Cohen, Guy wrote:
> However, the vast majority of iwlwifi users at this point run it over
> little-endian platforms.

That would be 100% as it doesn't yet support big-endian platforms?

 ciao
     Joerg

-- 
Joerg Mayer                                           <jmayer@loplof.de>
We are stuck with technology when what we really want is just stuff that
works. Some say that should read Microsoft instead of technology.
