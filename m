Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34253 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbYJVKKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 06:10:07 -0400
Date: Wed, 22 Oct 2008 06:07:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: reinette chatre <reinette.chatre@linux.intel.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: New iwlwifi 3945 uCode available
Message-ID: <20081022100758.GA27595@infradead.org> (sfid-20081022_121023_825735_C6F92286)
References: <1224613633.10863.43.camel@rc-desk> <1224624324.28639.9.camel@johannes.berg> <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com> <1224624899.28639.17.camel@johannes.berg> <20081021213814.GM17268@tuxdriver.com> <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com> <1224627187.9386.103.camel@californication> <1224628088.10863.100.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1224628088.10863.100.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 03:28:08PM -0700, reinette chatre wrote:
> I do not believe our request is unreasonable. If a user runs a new
> kernel the log will print a message that the firmware is incorrect ...
> all the user needs to do is go to
> http://intellinuxwireless.org/?n=Downloads and download the latest
> firmware. This does not require any subtle changes that may affect other
> aspects of the system ... just the firmware file that is only used by
> the driver.

with the wireless that doesn't work.  Nice.  Sorry guys, but requiring
a new firmware version for a new driver release is completely
unreasonable.  You can drop support for older firmware ABIs after a few
years, but not immediately.

