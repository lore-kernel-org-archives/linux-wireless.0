Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:57230 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbZKRXMi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 18:12:38 -0500
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and
 why?
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: madwifi-users@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	madwifi-devel@lists.sourceforge.net,
	David Acker <dacker@roinet.com>,
	Andrey Yurovsky <andrey@cozybit.com>
In-Reply-To: <43e72e890911181408r43dadf7av277b255eb9007481@mail.gmail.com>
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de>
	 <43e72e890911171337p4b0d97fcp844266137bb51b56@mail.gmail.com>
	 <4B03193E.2080304@roinet.com>
	 <43e72e890911171345q2dc59d66g6ac2a9eec04c577c@mail.gmail.com>
	 <4B031B48.1090105@roinet.com>
	 <43e72e890911171404x1a46d07alb54946768d0f9cf5@mail.gmail.com>
	 <4B032390.3080501@roinet.com> <20091117225408.GA20540@jm.kir.nu>
	 <43e72e890911171512k562f9329td56cc741dd1c5151@mail.gmail.com>
	 <1258581492.10593.24.camel@mj>
	 <43e72e890911181408r43dadf7av277b255eb9007481@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 18 Nov 2009 18:12:33 -0500
Message-Id: <1258585953.9914.5.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-11-18 at 14:08 -0800, Luis R. Rodriguez wrote:

> So for now countries either take the FCC, are part of a larger group
> like in Europe or are a head ache to deal with due to historical
> changes on regulatory rules (Japan). So far I've seen rules set for
> bands and with max EIRP and antenna gain. Sometimes you have quirky
> rules for antenna gain like in the US for the 3:1 rule (but we don't
> yet allow you to modify your antenna on linux and specific your new
> dbi antenna gain, and this actually is assumed won't change on the
> client side).
> 
> For width I'm told some countries do not allow HT40 and that this
> should change in the future.
> 
> I haven't seen rules for finer level of control which is why I said I
> we should not need to change anything. Right now  I've only have heard
> of countries sometimes disallowing HT40, but that's it.
> 
> Are you aware of any regulatory rules which prohibit narrower
> channels? It just seems odd.

No, I'm not aware of such limitations.  OK, you are not aware of such
limitations either, then perhaps we can go ahead with the narrow
channels.

-- 
Regards,
Pavel Roskin
