Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:33154 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbZGMOIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 10:08:52 -0400
Received: by mail-yx0-f184.google.com with SMTP id 14so3120059yxe.33
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 07:08:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090712203449.GA3058@sprite>
References: <20090630170916.GB5137@sprite> <20090712112340.GA3315@sprite>
	 <40f31dec0907120808y45f575b6l6d83afd731e6d51@mail.gmail.com>
	 <20090712203449.GA3058@sprite>
Date: Mon, 13 Jul 2009 10:08:52 -0400
Message-ID: <b6c5339f0907130708h3996b274qdcc7d7f6056a188c@mail.gmail.com>
Subject: Re: ath5k and Atheros AR242x - No scan results
From: Bob Copeland <me@bobcopeland.com>
To: Joel Roth <joelz@pobox.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 12, 2009 at 4:34 PM, Joel Roth<joelz@pobox.com> wrote:
> Vista advised me to:
>
> 1) turn on the hardware wifi switch <blush>
>
> 2) use the hotkey combination to enable wifi

It might be worth trying compat-wireless or 2.6.31-rcX.  Support
for reading the card's internal rfkill state was added in the
post-2.6.30 time-frame.

-- 
Bob Copeland %% www.bobcopeland.com
