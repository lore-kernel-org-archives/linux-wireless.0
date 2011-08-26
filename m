Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3439 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab1HZTbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 15:31:08 -0400
Date: Fri, 26 Aug 2011 12:30:58 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "David Woodhouse" <dwmw2@infradead.org>
cc: "=?iso-8859-1?Q?G=E1bor?= Stefanik" <netrolller.3d@gmail.com>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH 2/3] b43: LCN-PHY: implement disabling radio
Message-ID: <20110826193058.GO4888@broadcom.com> (sfid-20110826_213113_096805_D98CE3E1)
References: <1313357250-8292-1-git-send-email-zajec5@gmail.com>
 <1313357250-8292-2-git-send-email-zajec5@gmail.com>
 <CA+XFjio4gg5zO-gx+6v2rLGidziNY-rUachmdt02VwE9tX_SWQ@mail.gmail.com>
 <1313414343.3990.6.camel@shinybook.infradead.org>
MIME-Version: 1.0
In-Reply-To: <1313414343.3990.6.camel@shinybook.infradead.org>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 15, 2011 at 06:18:57AM -0700, David Woodhouse wrote:
> On Mon, 2011-08-15 at 01:24 +0200, Gábor Stefanik wrote:
> > Doesn't brcm80211 support this PHY? (Because then, reverse-engineering
> > wl is pointless.)
> 
> I'd be great to "clean up" the interface between brcm80211 and its phy
> code, so that the phy code can be moved out of drivers/staging. And once
> we've done that, we can make b43 use it too.
> 
> That way we not only get LCN PHY code, but also hopefully support for
> *other* PHYs as and when they are produced.

If you have any specific cleanup suggestions for the phy code, please send them
along.

- Henry

