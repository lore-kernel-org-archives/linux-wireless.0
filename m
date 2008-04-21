Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.235]:42444 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbYDUOxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 10:53:33 -0400
Received: by wr-out-0506.google.com with SMTP id c48so808120wra.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 07:53:31 -0700 (PDT)
Message-ID: <c85cb4470804210753q394962f9lcd03d6c4beed077f@mail.gmail.com> (sfid-20080421_165436_409223_3ECF0FC8)
Date: Mon, 21 Apr 2008 17:53:29 +0300
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [2.6 patch] make sta_rx_agg_session_timer_expired() static
Cc: "Adrian Bunk" <bunk@kernel.org>,
	"Tomas Winkler" <tomas.winkler@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1208769228.26186.58.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080421084751.GI26897@cs181133002.pp.htv.fi>
	 <1208769228.26186.58.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Mon, 2008-04-21 at 11:47 +0300, Adrian Bunk wrote:
> > sta_rx_agg_session_timer_expired() can now become static.
> >
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> Good plan, thanks.
>
> johannes

Agree, thanks

Ron
