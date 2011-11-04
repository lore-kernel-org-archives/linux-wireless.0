Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53890 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab1KDKHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 06:07:03 -0400
Subject: Re: [PATCH v2] cfg80211: merge in beacon ies of hidden bss.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAMG6FYgvkjYENbE9ud16HthVF4aeSDqM5McnKDr77XxOD542eA@mail.gmail.com> (sfid-20111104_095948_340881_9E95CAAA)
References: <CAMG6FYg__nsSLa93AmzcMgckg8HG3FjD3LxpyDfA77WTsVm0oA@mail.gmail.com>
	 <1320395185.3969.4.camel@jlt3.sipsolutions.net>
	 <CAMG6FYgvkjYENbE9ud16HthVF4aeSDqM5McnKDr77XxOD542eA@mail.gmail.com>
	 (sfid-20111104_095948_340881_9E95CAAA)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 11:07:01 +0100
Message-ID: <1320401221.3969.76.camel@jlt3.sipsolutions.net> (sfid-20111104_110707_886959_56FD65C4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Since we need to fix cmp_ie() anyway, how about we change it there as
> > well. I'm going to post a patch.

> I assume there is some (unclear for me) idea behind the order of operation
> in the cmp_ie comparator. Natural order of scan output?

Well, the sort order here matters only for the tree search and is
clearly broken for that. I just sent a patch to fix that.

johannes

