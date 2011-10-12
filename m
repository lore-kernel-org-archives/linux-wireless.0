Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51132 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1JLDTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 23:19:44 -0400
Received: by iaek3 with SMTP id k3so302900iae.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 20:19:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <op.v27ru00wya27un@edmitar>
References: <op.v27ru00wya27un@edmitar>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 12 Oct 2011 14:19:23 +1100
Message-ID: <CAGRGNgWFL=t3mJrCt9xkWSEJ=TGUGZLW4qARF=x7Ccg90jnt=g@mail.gmail.com> (sfid-20111012_051948_142349_B3C1AABD)
Subject: Re: [RFC 06/07] compat-wireless: UAPSD configuration in STA mode
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: "linux-wireless.vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bartosz MARKOWSKI <bartosz.markowski@tieto.com>,
	Janusz DZIEDZIC <janusz.dziedzic@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

Some minor comments on this patch:

Note that I'm not a maintainer and that these are comments on the
patch itself, not the code it adds.

Again, this is marked as a compat-wireless patch, but you're modifying
files that aren't in compat-wireless. Are you sure this patch is
correct?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
