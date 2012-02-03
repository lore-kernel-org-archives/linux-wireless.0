Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3178 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757435Ab2BCVD4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 16:03:56 -0500
Message-ID: <4F2C4BB2.1070207@broadcom.com> (sfid-20120203_220400_099661_3815E541)
Date: Fri, 3 Feb 2012 22:03:46 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Daniel Smith" <viscous.liquid@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: Broadcom brcm80211 monitor mode
References: <CADGLRPncrRHRFUXHfUWM31d0THzuJx_2a=+aifcFR39jT7WpLA@mail.gmail.com>
In-Reply-To: <CADGLRPncrRHRFUXHfUWM31d0THzuJx_2a=+aifcFR39jT7WpLA@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/03/2012 09:01 PM, Daniel Smith wrote:
> Hi
> 
> I see on the "To be done list" for both the fullmac and softmac chips
> is to add support for monitor mode. I was wondering how realistic is
> that task. If it is definitely going to occur, any idea what it will
> support, e.g. capturing management frames. Also any kind of hint what
> kind of time frame are you looking at? Any info would be greatly
> appreciated.
> 
> V/r,
> Daniel Smith
> 

For brcmsmac it has already been done just using the radiotap
functionality. I did not implement it, but I think this functionality is
provided by cfg80211. Not sure if that is sufficient info.

Gr. AvS

