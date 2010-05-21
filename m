Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:60531 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab0EUASx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 20:18:53 -0400
Received: by pxi18 with SMTP id 18so178094pxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 17:18:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274181228.3762.78.camel@jlt3.sipsolutions.net>
References: <19442.25652.916516.143181@gargle.gargle.HOWL>
	<1274181228.3762.78.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 20 May 2010 17:18:33 -0700
Message-ID: <AANLkTinJtLScvxYrXG3CpziTMuKSlySd1SJquLibOntQ@mail.gmail.com>
Subject: Re: [PATCH] ath9k_htc: Use proper station add/remove callbacks
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith <Sujith.Manoharan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 18, 2010 at 4:13 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-05-18 at 15:26 +0530, Sujith wrote:
>> sta_add/sta_remove are the callbacks that can sleep.
>> Use them instead of sta_notify.
>>
>> Sigh. What a dumb fsckup.
>
> Not really your fault? The sleeping ones are quite new.

John, this fix might be a 2.6.35 fix although not noted as such.

  Luis
