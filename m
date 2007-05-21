Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:45782 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763787AbXEUWQY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2007 18:16:24 -0400
Message-ID: <46521A1C.8040708@garzik.org>
Date: Mon, 21 May 2007 18:15:56 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "Cohen, Guy" <guy.cohen@intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
References: <D0122E209EBF8D4CAB38EC6A8AF244E5028B1C57@hasmsx412.ger.corp.intel.com>
In-Reply-To: <D0122E209EBF8D4CAB38EC6A8AF244E5028B1C57@hasmsx412.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cohen, Guy wrote:
> But at this point (we can't change the past nor the present), we would
> like to focus on more urgent issues with iwlwifi in the immediate term
> and delay a bit the big-endian support. Is this acceptable?


Your internal schedule is your internal schedule.

But as I previously stated, getting rid of the bitfields and using the 
proper (portable) Linux driver API is a hard merge requirement.

	Jeff


