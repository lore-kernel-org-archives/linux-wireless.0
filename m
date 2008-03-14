Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3517 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbYCNBwr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2008 21:52:47 -0400
Date: Thu, 13 Mar 2008 21:29:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] mac80211: Tkip fix sparse endianity complain in
	tkip code
Message-ID: <20080314012900.GC31964@tuxdriver.com> (sfid-20080314_015249_748899_204C84FE)
References: <1205431553-20567-1-git-send-email-tomas.winkler@intel.com> <1205442130.15910.18.camel@johannes.berg> <1ba2fa240803131657o3858f12ey1b55d0f23a216f7f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240803131657o3858f12ey1b55d0f23a216f7f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 14, 2008 at 01:57:39AM +0200, Tomas Winkler wrote:
> On Thu, Mar 13, 2008 at 11:02 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:

> >  The patch introducing this code will be reverted because this is also
> >  rather bad code since it's not known that "pos" is aligned to a
> >  four-byte boundary.
> 
> Agree, actually I was puzzled it was even merged in after all these
> discussions. Anyhow it sparsed into my eye so I put a patch on it.

The beauty of the wireless-testing tree is it gives me more freedom
to merge patches without being married to them. :-)

John
-- 
John W. Linville
linville@tuxdriver.com
