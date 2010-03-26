Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48807 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab0CZVQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 17:16:28 -0400
Received: by pva18 with SMTP id 18so1675735pva.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Mar 2010 14:16:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1269637855.4342.157.camel@jlt3.sipsolutions.net>
References: <20100324120645.5b43757c.nledovskih@mail.ru>
	 <445f43ac1003241816p2d00b79br224a155b605ce7ac@mail.gmail.com>
	 <445f43ac1003261114h55918152rd76be84c97716c99@mail.gmail.com>
	 <1269637855.4342.157.camel@jlt3.sipsolutions.net>
Date: Fri, 26 Mar 2010 14:16:26 -0700
Message-ID: <445f43ac1003261416g357f4fe1qf36de3b0c2fec46d@mail.gmail.com>
Subject: Re: Mesh mode broken since 2.6.34-rc1
From: Javier Cardona <javier@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?KOI8-R?B?7MXEz9fTy8nIIO7Jy8/Mwcog98HMxdLYxdfJ3g==?=
	<nledovskih@mail.ru>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	devel@lists.open80211s.org,
	"Porsch, Marco" <marco.porsch@siemens.com>,
	Steve deRosier <steve@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

> The proper fix will probably be to make
> ieee80211_rx_h_action() aware of the frames that mesh/mlme wants to
> handle it and not reject then.

Thanks, Johannes.  We are working on a patch along these lines.  No
need to trouble yourself except for reviewing it when we send it.

Cheers,

Javier



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
