Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:42017 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491Ab2FTNjk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 09:39:40 -0400
Received: by lbbgm6 with SMTP id gm6so624427lbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 06:39:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340194342.4655.59.camel@jlt3.sipsolutions.net>
References: <1340177634-24568-1-git-send-email-victorg@ti.com>
	<1340178370.4655.22.camel@jlt3.sipsolutions.net>
	<CAK80WHYU+dOvMQG2aDTP7rO6b=MZXDVcX4a7KGpLizgutVcD8g@mail.gmail.com>
	<1340180991.4655.30.camel@jlt3.sipsolutions.net>
	<CAK80WHbMVr0GVrKRGL9OD8CUHi8FBVRL0tDGewf9doLm2etb0g@mail.gmail.com>
	<1340194342.4655.59.camel@jlt3.sipsolutions.net>
Date: Wed, 20 Jun 2012 16:39:37 +0300
Message-ID: <CAK80WHbbPHSnbqbirQA5QT_Dbc+fT4xY7iu43VAQo0c-2KuHYg@mail.gmail.com> (sfid-20120620_153943_268587_0FC1C8B6)
Subject: Re: [PATCH v3 1/2] nl80211/cfg80211: add scan channel times to scan command
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, eliad@wizery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2012 at 3:12 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:

>
> It makes a lot more sense than your way which can result in invalid
> configurations being passed to the driver ...
>


I will respin.


-- 
Thanks,
Victor.
