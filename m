Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f180.google.com ([209.85.161.180]:62633 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0LGICZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 03:02:25 -0500
Received: by gxk19 with SMTP id 19so7345779gxk.11
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 00:02:24 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19709.59888.682471.11803@gargle.gargle.HOWL>
Date: Tue, 7 Dec 2010 13:31:52 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Sujith <m.sujith@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k_htc: Fix suspend/resume
In-Reply-To: <AANLkTinJLRMSSvLHgPP1Dw5BXsC3utAudJ=oSAsUUD8T@mail.gmail.com>
References: <19701.62091.644444.121284@gargle.gargle.HOWL>
	<20101202193024.GC2358@tuxdriver.com>
	<19704.23185.565826.890275@gargle.gargle.HOWL>
	<AANLkTinPLPoAHxauaXj8Sj=zjyHQPyxO0ku342ersZQ4@mail.gmail.com>
	<19709.45926.38551.25130@gargle.gargle.HOWL>
	<AANLkTinNF2dnacLof_knM3OAf6ADCCPsb8DO1VE6c31U@mail.gmail.com>
	<19709.46740.86437.390791@gargle.gargle.HOWL>
	<AANLkTinJLRMSSvLHgPP1Dw5BXsC3utAudJ=oSAsUUD8T@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Oh right, I see. Should we not wait to turn the radio until we get a
> non-idle config() call?

Ideally, yes. But that would require extensive changes in ath9k_hw.
Initialization has to be pruned, powering up the chip has to be deferred ...

Which is why I decided to settle for a simple band-aid for now. :)

Sujith
