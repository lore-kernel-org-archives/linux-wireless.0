Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44367 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab2KNJbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 04:31:50 -0500
Message-ID: <1352885539.9510.17.camel@jlt4.sipsolutions.net> (sfid-20121114_103155_022016_3DCC2BC9)
Subject: Re: [PATCH v7 2/2] wireless: integrate wil6210 driver into build
 structure
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	Vladimir Kondratiev <vkondrat_qca@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 14 Nov 2012 10:32:19 +0100
In-Reply-To: <4652801.Xt8tN7pgs4@lx-vladimir>
References: <1352809427-29682-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1352836486.9466.25.camel@jlt4.sipsolutions.net>
	 <CAGRGNgXsGh1qLo8gq+L5Uedu=F=Eob_9j4x6jxrEg_=wPnOfWA@mail.gmail.com>
	 <4652801.Xt8tN7pgs4@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[btw, you seem to have started to send HTML email that almost looks like
plain text for some reason]

> > It might be even better to split it out into a separate patch.
> 
>  
> 
> Sure I can do this. One patch for change regarding ATH_COMMON, another
> one that introduces wil6210 module.

> Anyone else have opinion what is better - keep one patch or split it?
> Johannes, what would you say?

I guess it woulod make sense, that patch could go in right away without
any further discussion, so it also reduces the code that's still being
discussed?

johannes

