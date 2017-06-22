Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:52411 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752743AbdFVWRY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 18:17:24 -0400
Date: Fri, 23 Jun 2017 00:17:14 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Thierry Escande <thierry.escande@collabora.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 0/2] NFC-digital: Adjustments for four function
 implementations
Message-ID: <20170622221714.GC21214@zurbaran.ger.intel.com> (sfid-20170623_001754_019275_71C8B14B)
References: <7e27a76c-de7a-22ec-cf8a-31aee2000e29@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7e27a76c-de7a-22ec-cf8a-31aee2000e29@users.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Markus,

On Mon, May 22, 2017 at 02:57:42PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 22 May 2017 14:50:05 +0200
> 
> Two update suggestions were taken into account
> from static source code analysis.
> 
> Markus Elfring (2):
>   Improve a size determination in four functions
>   Delete an error message for a failed memory allocation in digital_in_send()
Both patches applied to nfc-next, thanks.

Cheers,
Samuel.
