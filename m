Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:2535 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab3IWMOQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Sep 2013 08:14:16 -0400
Date: Mon, 23 Sep 2013 20:14:02 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hante Meuleman <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [brcmfmac] BUG: unable to handle kernel paging request at
 ffffffff82196446
Message-ID: <20130923121402.GA12626@localhost> (sfid-20130923_141432_034044_0EF151A2)
References: <20130902102327.GB14264@localhost>
 <5236CC49.7000206@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5236CC49.7000206@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 16, 2013 at 11:15:53AM +0200, Arend van Spriel wrote:
> On 09/02/2013 12:23 PM, Fengguang Wu wrote:
> >Greetings,
> >
> >I got the below dmesg and the first bad commit is
> 
> Hi Fengguang,
> 
> I could not reproduce this issue. Could you retest with the attached
> patch file applied and let me know if that fixes the problem?

Yeah it fixed the problem: no more oops in 1000 kernel boot tests. Thank you!

Cheers,
Fengguang
