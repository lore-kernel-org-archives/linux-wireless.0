Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35984 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757547AbXEUVq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2007 17:46:58 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
Date: Tue, 22 May 2007 00:46:45 +0300
Message-ID: <D0122E209EBF8D4CAB38EC6A8AF244E5028B1C58@hasmsx412.ger.corp.intel.com>
In-Reply-To: <20070521212209.GX1955@thot.informatik.uni-kl.de>
From: "Cohen, Guy" <guy.cohen@intel.com>
To: "Joerg Mayer" <jmayer@loplof.de>
Cc: "Christoph Hellwig" <hch@infradead.org>,
	"James Ketrenos" <jketreno@linux.intel.com>,
	"Jeff Garzik" <jeff@garzik.org>,
	"Randy Dunlap" <randy.dunlap@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



From: Joerg Mayer [mailto:jmayer@loplof.de]
>On Mon, May 21, 2007 at 11:12:17PM +0300, Cohen, Guy wrote:
>> However, the vast majority of iwlwifi users at this point run it over
>> little-endian platforms.
>
>That would be 100% as it doesn't yet support big-endian platforms?
>

:)

I meant potential users...

> ciao
>     Joerg
