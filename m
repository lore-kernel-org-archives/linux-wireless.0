Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:39649 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333Ab2G0LjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:39:01 -0400
Received: by yhnn12 with SMTP id n12so2728224yhn.10
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 04:38:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343382848.4449.2.camel@jlt3.sipsolutions.net>
References: <1343373093-10065-1-git-send-email-arik@wizery.com>
	<1343382848.4449.2.camel@jlt3.sipsolutions.net>
Date: Fri, 27 Jul 2012 14:38:48 +0300
Message-ID: <CAKd1q9oudZ8bg9iuEV4LbU6+caVhbFiY6kgrU+mqu4Wm1syOXQ@mail.gmail.com> (sfid-20120727_133906_987981_2A2593F5)
Subject: Re: [PATCH 0/2] wlcore tx rework
From: "Coelho, Luciano" <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Fine by me.

Acked-by: Luciano Coelho <coelho@ti.com>


On 7/27/12, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-07-27 at 10:11 +0300, Arik Nemtsov wrote:
>> Get the hlid of a queued skb from driver internal info instead of the
>> sta inside the skb cb. Rework some functions so that the sta is passed
>> explicitly during op_tx.
>>
>> Testd in STA + AP modes.
>>
>> Johannes - would you like to take these via your tree, as a prerequisite
>> for Thomas' patch?
>
> I think I will if nobody objects (Luca? John?), rather than trying to
> organise this with multiple trees.
>
> johannes
>
>
