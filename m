Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37355 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0I2XDu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 19:03:50 -0400
Received: by iwn5 with SMTP id 5so1597746iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Sep 2010 16:03:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285783383-20822-1-git-send-email-greearb@candelatech.com>
References: <1285783383-20822-1-git-send-email-greearb@candelatech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 30 Sep 2010 09:03:29 +1000
Message-ID: <AANLkTi=HC6bXdjkUgS9Evo5JgbAMiz3EAt_E7GJs9QZF@mail.gmail.com>
Subject: Re: [PATCH 1/2] mac80211: Make no-probe-response kernel messages more useful.
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 30, 2010 at 04:03,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Add device name and flags to give better idea of what
> exactly is happening.

Is there a printk variant that does standardised formatting for the
wireless device name?

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
