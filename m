Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47554 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab2CWOGw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 10:06:52 -0400
Date: Fri, 23 Mar 2012 15:15:00 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Eric Lapuyade <eric.lapuyade@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: Re: [PATCH] NFC: Add Core support to generate tag lost event
Message-ID: <20120323141500.GD7231@sortiz-mobl> (sfid-20120323_150655_161283_232922FB)
References: <4F6C5C59.2060708@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F6C5C59.2060708@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eric,

On Fri, Mar 23, 2012 at 12:19:53PM +0100, Eric Lapuyade wrote:
> Some HW/drivers get notifications when a tag moves out of the radio field.
> This notification is now forwarded to user space through netlink.
Thanks, applied to my nfc-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
