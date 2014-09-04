Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:44427 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198AbaIDXDr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 19:03:47 -0400
Date: Fri, 5 Sep 2014 01:03:12 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@ml01.01.org,
	kernel-janitors@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [patch -RESEND] NFC: potential overflows in
 microread_target_discovered()
Message-ID: <20140904230312.GA6702@zurbaran> (sfid-20140905_010400_425880_FB7ECA04)
References: <20140901172729.GA6549@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140901172729.GA6549@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Mon, Sep 01, 2014 at 08:27:29PM +0300, Dan Carpenter wrote:
> Smatch says that skb->data is untrusted so we need to check to make sure
> that the memcpy() doesn't overflow.
Applied to nfc-fixes, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
