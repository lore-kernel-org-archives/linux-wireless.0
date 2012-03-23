Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22315 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab2CWLXl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 07:23:41 -0400
Date: Fri, 23 Mar 2012 12:31:50 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Eric Lapuyade <eric.lapuyade@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: Re: [PATCH] NFC: Changed target activated state logic
Message-ID: <20120323113150.GC7231@sortiz-mobl> (sfid-20120323_122344_540730_8FED2EFF)
References: <4F6C5B05.40003@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F6C5B05.40003@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eric,

On Fri, Mar 23, 2012 at 12:14:13PM +0100, Eric Lapuyade wrote:
> As we need to maintain the currently activated target idx, use this variable instead of the redundant remote_activated bool.
> 
Applied to my nfc-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
