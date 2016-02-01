Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35658 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbcBAJdz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 04:33:55 -0500
Date: Mon, 1 Feb 2016 15:03:46 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix memory leak
Message-ID: <20160201093346.GA10500@sudip-pc> (sfid-20160201_103425_611182_B3F729EB)
References: <1454060944-11320-1-git-send-email-sudipm.mukherjee@gmail.com>
 <CAGRGNgXc9PtYY=hb8nNRt4T5YGm2vexcJ01Z1fCCcb=57WRZ3g@mail.gmail.com>
 <20160201042548.GA4072@sudip-pc>
 <878u34u6d6.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <878u34u6d6.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 01, 2016 at 11:28:37AM +0200, Kalle Valo wrote:
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:
> 
> > On Mon, Feb 01, 2016 at 11:03:35AM +1100, Julian Calaby wrote:
> >> Hi Sudip,
> >> 
> >> On Fri, Jan 29, 2016 at 8:49 PM, Sudip Mukherjee
> >> <sudipm.mukherjee@gmail.com> wrote:
> >> > On error we jumped to the error label and returned the error code but we
> >> > missed releasing sinfo.
> >> >
> >> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> >> 
> >> Should the From: and Signed-off-by: email addresses be the same?
> >
> > I think 2 years back I had a long discussion with Greg about this and
> > since then I al submitting patches like this. A small summayg of the
> > problem from that discussion:
> >
> > "we have strict DMARC check for the corporate mail server. DMARC =
> > domain based message authentication.
> > So the mail i sent reached all the list subscriber from a different
> > server than our designated server, and as a result it is marked as spam
> > in many places and I have already received a few complaints regarding
> > that."
> 
> You can add a separate "From:" line to the beginning of the commit log
> and git will use it then commiting the patch. I didn't find any
> documention but it's easy to do and should solve this.

Documentation is not needed. :)
I have done that couple of time.
I will resend this patch with the extra From: line.

regards
sudip
