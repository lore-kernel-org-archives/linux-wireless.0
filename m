Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:46718 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757749AbXEUUMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2007 16:12:25 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
Date: Mon, 21 May 2007 23:12:17 +0300
Message-ID: <D0122E209EBF8D4CAB38EC6A8AF244E5028B1C2D@hasmsx412.ger.corp.intel.com>
In-Reply-To: <20070521181543.GA838@infradead.org>
From: "Cohen, Guy" <guy.cohen@intel.com>
To: "Christoph Hellwig" <hch@infradead.org>,
	"James Ketrenos" <jketreno@linux.intel.com>
Cc: "Jeff Garzik" <jeff@garzik.org>,
	"Randy Dunlap" <randy.dunlap@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

Support for big-endian platforms (as well as AP mode) for iwlwifi is
currently *planned* to be added by Intel in the near future for several
purposes.

However, the vast majority of iwlwifi users at this point run it over
little-endian platforms. _Delaying_ the inclusion of iwlwifi driver will
not assist iwlwifi-over-big-endian-platform users in any way, but the
impact on the rest of the users is clear.

We got many comments from the community and we thank you for that. We do
our best to fix all of them in timely manner for the benefit of
everyone. If something falls between the cracks it is only because of
limited resources, priority issues, human mistakes or alike and not
because of flippancy or anything like that. I hope you understand that.

Guy.

PS
I marked *planned* with asterisks so no one mixes it by mistake with
*committed* and attack me if Intel stops making HW and SW, etc :)


On 5/21/07, Christoph Hellwig <hch@infradead.org> wrote:
>On Mon, May 21, 2007 at 09:48:30AM -0700, James Ketrenos wrote:
>> Second, regarding your prior thread, you more or less demanded that
the
>> driver maintainer send you hardware.  That isn't fair or reasonable.
>
> No, that's entirely false.  I'd more than happy to have it fixed
without
> me beeing involved.  I offered to test it in case it's really that
> difficult to get a foreign endian machine inside intel.
