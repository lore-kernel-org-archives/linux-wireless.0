Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:52285 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab1L3Il5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Dec 2011 03:41:57 -0500
Date: Fri, 30 Dec 2011 09:41:53 +0100
From: Ignacy Gawedzki <i@lri.fr>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Marek Lindner <lindner_marek@yahoo.de>
Subject: Re: [PATCH] net/mac80211/sta_info.c: Fix crash in
 ieee80211_sta_expire.
Message-ID: <20111230084153.GA7807@zenon.in.qult.net> (sfid-20111230_094200_377526_33FD1E54)
References: <20111229165800.GA7405@zenon.in.qult.net>
 <CAD2nsn2AZMPoOC1wuQ8CE9cWt8GhEEYQH8DO7c47ex+H+SEcXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD2nsn2AZMPoOC1wuQ8CE9cWt8GhEEYQH8DO7c47ex+H+SEcXg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 30, 2011 at 11:20:40AM +0530, thus spake Mohammed Shafi:
> Hi,
> 
> On Thu, Dec 29, 2011 at 10:28 PM, Ignacy Gawedzki <i@lri.fr> wrote:
> > Add missing brackets after applying ec2b774e7c91094d8c00de579646f1162b87b01e.
> 
> 
> its already addressed by the patch
> http://comments.gmane.org/gmane.linux.kernel.wireless.general/83198

Ah, very well then.  Sorry for the noise. =)

-- 
The groove will take you through times without money
much better than money will take you through times without groove.
