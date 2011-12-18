Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27141 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab1LRUhl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Dec 2011 15:37:41 -0500
Date: Sun, 18 Dec 2011 21:42:11 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 1/2] NFC: double unlock in nfc_llcp_recv_connect()
Message-ID: <20111218204211.GQ11800@sortiz-mobl> (sfid-20111218_213802_015342_77B4E8E8)
References: <20111216202529.GA18570@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111216202529.GA18570@elgon.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Fri, Dec 16, 2011 at 11:25:29PM +0300, Dan Carpenter wrote:
> We unlock inside the if block on the other side of this if else
> statement.  It could result in calling mutex_unlock() twice.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Thanks,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
