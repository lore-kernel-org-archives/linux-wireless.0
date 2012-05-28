Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52458 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab2E1UHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 16:07:41 -0400
Received: by pbbrp8 with SMTP id rp8so5001069pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 May 2012 13:07:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20419.9719.160216.124618@gargle.gargle.HOWL>
References: <4FC04B5A.1070900@candelatech.com>
	<20416.19680.571601.549629@gargle.gargle.HOWL>
	<4FC0F8CE.1030303@candelatech.com>
	<20417.972.888113.821079@gargle.gargle.HOWL>
	<20417.1857.115550.807746@gargle.gargle.HOWL>
	<4FC2437C.9090106@candelatech.com>
	<CAJ-Vmon13Q5icGU0oeQWaOaHF+jfhEZHyK2Y1xp5BwCgM_74pg@mail.gmail.com>
	<4FC2F73F.4070701@candelatech.com>
	<CAJ-VmonMtRUZpidJERT7hRUDJNgyoMdVovXoG5WdStH6zk7yFQ@mail.gmail.com>
	<20419.9719.160216.124618@gargle.gargle.HOWL>
Date: Mon, 28 May 2012 13:07:40 -0700
Message-ID: <CAJ-Vmokf+EfpQ9m_8W6q3q-nsKgMMTn0w7=BgnW26AWh5vZB2g@mail.gmail.com> (sfid-20120528_220812_996022_69FEA6C3)
Subject: Re: Anyone doing WiFi throughput tests?
From: Adrian Chadd <adrian@freebsd.org>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Heh. 228MBit is more reasonable, but I'm getting it up around
235/240MBit at the present moment. I'm hitting queue overruns though,
so I think I've messed something up in the driver, or someone broke
the scheduler in weird/wonderful ways.

I'll let you know when it's at 250MBit again. :)



Adrian
