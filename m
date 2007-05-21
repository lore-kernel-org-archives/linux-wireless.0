Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:45266 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760811AbXEUVCa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2007 17:02:30 -0400
Message-ID: <465208CA.8090201@garzik.org>
Date: Mon, 21 May 2007 17:02:02 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "Cohen, Guy" <guy.cohen@intel.com>
CC: Christoph Hellwig <hch@infradead.org>,
	James Ketrenos <jketreno@linux.intel.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
References: <D0122E209EBF8D4CAB38EC6A8AF244E5028B1C2D@hasmsx412.ger.corp.intel.com>
In-Reply-To: <D0122E209EBF8D4CAB38EC6A8AF244E5028B1C2D@hasmsx412.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cohen, Guy wrote:
> Support for big-endian platforms (as well as AP mode) for iwlwifi is
> currently *planned* to be added by Intel in the near future for several
> purposes.

> However, the vast majority of iwlwifi users at this point run it over
> little-endian platforms. _Delaying_ the inclusion of iwlwifi driver will
> not assist iwlwifi-over-big-endian-platform users in any way, but the
> impact on the rest of the users is clear.


All Linux drivers that use the proper APIs are transparently portable to 
either little endian or big endian, 32-bit or 64-bit machines.

If your driver is not portable, then it is not using the proper APIs, 
and needs updating.

Next time, write the driver using the correct APIs and you will not run 
into these sort of problems...

	Jeff




