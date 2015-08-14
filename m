Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36249 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbbHNVkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 17:40:11 -0400
Received: by wicja10 with SMTP id ja10so29427637wic.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2015 14:40:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEnVuW0JnU5yuAYBWsRfOo_S=GUK5vZzr6XqnNHHOeufmT-uiQ@mail.gmail.com>
References: <CAEnVuW0JnU5yuAYBWsRfOo_S=GUK5vZzr6XqnNHHOeufmT-uiQ@mail.gmail.com>
From: Allan Matthew <allanm84@gmail.com>
Date: Fri, 14 Aug 2015 14:39:50 -0700
Message-ID: <CAEnVuW1FcyBj2+ti8U8KF+rM0xO_Q+rw6PxXqgWy8WO0vRX6yg@mail.gmail.com> (sfid-20150814_234019_925894_43212D3A)
Subject: Re: set channel from radiotap headers during injection
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anyone have any thoughts on this?

Is it possible with channel context enabled somehow?

On Thu, Aug 13, 2015 at 11:22 AM, Allan Matthew <allanm84@gmail.com> wrote:
> I'd like to be able to set the channel information on a per-packet
> basis during monitor-mode injection.  Specifically, I would like to be
> able to change the channel bandwidth down to half and quarter rates
> (my PHY supports this) based on the radiotap header information.
> Additionally, if its possible to change the channel itself that would
> be desirable.
>
> I've been able to add rate and FEC control to
> ieee80211_parse_tx_radiotap, but I'm not sure where to start with
> setting channel information. Has anyone been able to do this?  If not,
> what do I need to set in order to get per-packet channel control?
