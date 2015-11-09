Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35237 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbbKIKbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 05:31:50 -0500
Date: Mon, 9 Nov 2015 15:53:42 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: punit vara <punitvara@gmail.com>
Cc: glen lee <glen.lee@atmel.com>, devel@driverdev.osuosl.org,
	chris.park@atmel.com, Austin Shin <austin.shin@atmel.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	linux-kernel@vger.kernel.org, tony.cho@atmel.com,
	leo.kim@atmel.com, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH V2] Staging: wilc1000: Fix build break due to undeclared
 *wilc and implicit declaration of init_irq
Message-ID: <20151109102342.GA3868@sudip-pc> (sfid-20151109_113155_396505_F33E87B8)
References: <1447018310-4524-1-git-send-email-punitvara@gmail.com>
 <20151108215953.GO18797@mwanda>
 <563FFEEB.1090307@atmel.com>
 <56405328.4040004@atmel.com>
 <20151109081842.GR18797@mwanda>
 <56405F71.6090404@atmel.com>
 <CABXAfNJHAWd_ygUbcZXDqwGvaCxM3nA5ibOF4sNwzhA3AP=07g@mail.gmail.com>
 <56406F0F.1050701@atmel.com>
 <CABXAfNKhtdRSm1BJK+pk9t4wwnFBXzAP_CKSVhS0p7m_FZG_8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CABXAfNKhtdRSm1BJK+pk9t4wwnFBXzAP_CKSVhS0p7m_FZG_8Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 09, 2015 at 03:43:38PM +0530, punit vara wrote:
> On Mon, Nov 9, 2015 at 3:31 PM, glen lee <glen.lee@atmel.com> wrote:
> >
> >
> > On 2015년 11월 09일 18:05, punit vara wrote:
> >>
> >> On Mon, Nov 9, 2015 at 2:25 PM, glen lee <glen.lee@atmel.com> wrote:
> >>>
> >>> On 2015년 11월 09일 17:18, Dan Carpenter wrote:
> >>>>
> >>>> On Mon, Nov 09, 2015 at 05:02:48PM +0900, glen lee wrote:
> >>>>>
> 
> make ./drivers/staging/wilc1000/    this working fine for me
> 
> but
> 
> make ./drivers/staging/wilc1000/linux_wlan.o is creates error.

I am also not getting build failure. Can you please post your .config file.

regards
sudip
