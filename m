Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:47787 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab3IPJuT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 05:50:19 -0400
Date: Mon, 16 Sep 2013 17:50:13 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hante Meuleman <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [brcmfmac] BUG: unable to handle kernel paging request at
 ffffffff82196446
Message-ID: <20130916095013.GA13395@localhost> (sfid-20130916_115022_497904_46A14170)
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

Sure. I've queued the patch for testing. Will report back 1-2 days
later.

Thanks,
Fengguang
