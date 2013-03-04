Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757546Ab3CDPsR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:48:17 -0500
Date: Mon, 4 Mar 2013 16:48:33 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-pci@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: is L1 really disabled in iwlwifi
Message-ID: <20130304154832.GD3021@redhat.com> (sfid-20130304_164822_193768_1E293EE8)
References: <CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com>
 <20130304134949.GB3021@redhat.com>
 <CANUX_P0JhuVWcQjTckYzG8eBb2MtT_=prKqV38mCpVjfLmGtCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P0JhuVWcQjTckYzG8eBb2MtT_=prKqV38mCpVjfLmGtCA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 04, 2013 at 04:57:46PM +0200, Emmanuel Grumbach wrote:

> This is what I did. On 3.7, lspci tells me that ASPM is enabled before
> I load the module. And same after I load the module.

CONFIG_PCIEASPM disabled ?

Stanislaw
