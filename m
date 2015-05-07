Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24092 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbbEGMUM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 08:20:12 -0400
Date: Thu, 7 May 2015 15:19:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: "Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl8723au : remove goto & return error directly
Message-ID: <20150507121934.GH14154@mwanda> (sfid-20150507_142018_065380_164B78C2)
References: <20150507111652.GA10574@IND12F0122>
 <wrfjk2wkoarp.fsf@ultrasam.lan.trained-monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <wrfjk2wkoarp.fsf@ultrasam.lan.trained-monkey.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 07, 2015 at 08:03:06AM -0400, Jes Sorensen wrote:
> "Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com> writes:
> > Remove the goto and return error directly thereby removing a variable
> >
> > Signed-off-by: Hari Prasath Gujulan Elango <hgujulan@visteon.com>
> > ---
> >  drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> NACK!

SHOUTING!

> 
> The goto is cleaner and more consistent, rather than hiding a return in
> the middle of the code.

More consistent with what?  There are already returns earlier in the
function.  Do-nothing gotos are pointless and annoying.

regards,
dan carpenter

