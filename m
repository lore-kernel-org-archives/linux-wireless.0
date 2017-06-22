Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:8092 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752741AbdFVWf3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 18:35:29 -0400
Date: Fri, 23 Jun 2017 00:35:24 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] nfc: nci: remove unnecessary null check
Message-ID: <20170622223524.GG21214@zurbaran.ger.intel.com> (sfid-20170623_003541_689324_8F1C3444)
References: <28317503-e721-2564-a9ff-82182aa0644a@roeck-us.net>
 <20170613163718.GA5375@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170613163718.GA5375@embeddedgus>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gustavo,

On Tue, Jun 13, 2017 at 11:37:18AM -0500, Gustavo A. R. Silva wrote:
> Remove unnecessary NULL check for pointer conn_info.
> conn_info is set in list_for_each_entry() using container_of(),
> which is never NULL.
> 
> Addresses-Coverity-ID: 1362349
> Cc: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>  net/nfc/nci/core.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
