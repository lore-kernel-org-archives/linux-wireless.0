Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:33127 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab1H1KdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 06:33:14 -0400
Received: by yie30 with SMTP id 30so2797907yie.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 03:33:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314294486.2296.306.camel@cumari>
References: <1314288270-22380-1-git-send-email-eliad@wizery.com>
	<1314288270-22380-4-git-send-email-eliad@wizery.com>
	<1314294486.2296.306.camel@cumari>
Date: Sun, 28 Aug 2011 13:33:13 +0300
Message-ID: <CAB3XZEenFrqzPbJcE=WrgWYhra5_PBbRrohZp1YbR5ZNpTpC0A@mail.gmail.com> (sfid-20110828_123326_680651_253A6E63)
Subject: Re: [PATCH 4/5] wl12xx: add config_hangover command
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2011 at 8:48 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Thu, 2011-08-25 at 19:04 +0300, Eliad Peller wrote:
>> +     acx->increase_delta = conf->increase_delta;
>> +     acx->decrease_delta = conf->decrease_delta;
>> +     acx->quiet_time = conf->quiet_time;
>> +     acx->increase_delta = conf->increase_time;
>
> Typo, this should be acx->increase_time.
>
good catch. thanks.
i'll send v2.

Eliad.
