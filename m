Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:50443 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab1LAPzJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 10:55:09 -0500
Date: Thu, 1 Dec 2011 16:59:51 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] nfc: Use standard logging styles
Message-ID: <20111201155951.GF22609@sortiz-mobl> (sfid-20111201_165535_069493_D26F14F4)
References: <cover.1322595343.git.joe@perches.com>
 <6c89a76ddb76926febe36fe5be514cb186e39a76.1322595343.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6c89a76ddb76926febe36fe5be514cb186e39a76.1322595343.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

On Tue, Nov 29, 2011 at 11:37:32AM -0800, Joe Perches wrote:
> Using the normal logging styles is preferred over
> subsystem specific styles when the subsystem does
> not take a specific struct.
> 
> Convert nfc_<level> specific messages to pr_<level>
> Add newlines to uses.
> 
I would be fine with moving to pr_debug, but I'd like the pr_fmt() routine to
include the function name as well.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
