Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45939 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbbC3KGV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 06:06:21 -0400
Message-ID: <1427709972.26117.26.camel@sipsolutions.net> (sfid-20150330_120626_959962_B9FAA748)
Subject: Re: [PATCH] mac80211: fix failed to set smps
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: miaoqing@qti.qualcomm.com, John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@qca.qualcomm.com
Date: Mon, 30 Mar 2015 12:06:12 +0200
In-Reply-To: <CABPxzYL16NbubDBLcRvtLmPSz8pMezJq627AFSVWyaj41WSxBQ@mail.gmail.com> (sfid-20150330_113447_042212_D72E76E0)
References: <1427433674-5745-1-git-send-email-miaoqing@qca.qualcomm.com>
	 <1427705012.26117.11.camel@sipsolutions.net>
	 <CABPxzYL16NbubDBLcRvtLmPSz8pMezJq627AFSVWyaj41WSxBQ@mail.gmail.com>
	 (sfid-20150330_113447_042212_D72E76E0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-30 at 15:04 +0530, Krishna Chaitanya wrote:
> On Mon, Mar 30, 2015 at 2:13 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2015-03-27 at 13:21 +0800, miaoqing@qti.qualcomm.com wrote:
> >> From: Miaoqing Pan <miaoqing@qca.qualcomm.com>
> >>
> >> Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
> >
> > Since you give no commit log, I can only guess what you're trying to do,
> > but I suppose you need to use "echo -n" instead of "echo".
> Johannes,
> 
> We had this discussion earlier also, i still strongly feel all cases
> must work with "echo" by default, as people are not that familiar
> to use "echo -n".

Well I still strongly feel that accepting garbage on the input like this
patch will do is wrong.

johannes


