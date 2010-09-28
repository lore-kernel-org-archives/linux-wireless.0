Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59682 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757420Ab0I1Szm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 14:55:42 -0400
Received: by ewy23 with SMTP id 23so1961040ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 11:55:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285699064-16491-1-git-send-email-greearb@candelatech.com>
References: <1285699064-16491-1-git-send-email-greearb@candelatech.com>
Date: Tue, 28 Sep 2010 14:45:22 -0400
Message-ID: <AANLkTiktoyg8T-vg5RCXOqQjBpSgFYdb5qs41GOxw6SE@mail.gmail.com>
Subject: Re: [PATCH v5] ath5k: Allow ath5k to support virtual STA and AP interfaces.
From: Bob Copeland <me@bobcopeland.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 28, 2010 at 2:37 PM,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Support up to 4 virtual APs and as many virtual STA interfaces
> as desired.
>
> This patch is ported forward from a patch that Patrick McHardy
> did for me against 2.6.31.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---

A useful thing to do when revising a patch is to include a changelog
right here (after the "---"), saying, e.g.

v5: changed a, b, c, and d.
v4: ...
v3: ...

E.g. some of Bruno's comments don't seem to be addressed here;
it would be good to know what's different from v4.

-- 
Bob Copeland %% www.bobcopeland.com
