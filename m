Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:43975 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbYBZXdW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 18:33:22 -0500
To: Pavel Roskin <proski@gnu.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath5k WARNING: at ieee80211_rate.h:149
References: <m38x17sk2g.fsf@maximus.localdomain>
	<20080226193326.GC3013@tuxdriver.com> <1204066971.19041.16.camel@dv>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 27 Feb 2008 00:33:21 +0100
In-Reply-To: <1204066971.19041.16.camel@dv> (Pavel Roskin's message of "Tue\, 26 Feb 2008 18\:02\:51 -0500")
Message-ID: <m363wbcmym.fsf@maximus.localdomain> (sfid-20080226_233327_220495_F230989A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@gnu.org> writes:

> There are indeed endian issues reported by sparse in the IBSS code.
> I've just submitted a patch.  Not sure if they are relevant to the
> issue, but I think it's worth trying.

Actually these two warnings usually don't show up, it's once per maybe
5 or 10 restarts. We will see.
-- 
Krzysztof Halasa
