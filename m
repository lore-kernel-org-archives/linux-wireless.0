Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53519 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1JWNKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Oct 2011 09:10:34 -0400
Received: by gyb13 with SMTP id 13so4997131gyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Oct 2011 06:10:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1319190767.3964.8.camel@jlt3.sipsolutions.net>
References: <CAG5dHkRULKh90W1MeR3zq+-gpeNUshrHZ0qbKXsW19PMG5enoQ@mail.gmail.com>
	<1319190767.3964.8.camel@jlt3.sipsolutions.net>
Date: Sun, 23 Oct 2011 17:10:33 +0400
Message-ID: <CAG5dHkQtVC-cgEWcZOC_woLGeQ75Pkg-JmETWxVKJGdHs8qoOA@mail.gmail.com> (sfid-20111023_151043_769900_C761393B)
Subject: Re: [RFC 1/7] mac80211: mesh power mode indication in QoS frames
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 October 2011 13:52, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2011-10-21 at 12:36 +0400, Ivan Bezyazychnyy wrote:
>
>> +/* mesh power save level subfield mask */
>> +#define IEEE80211_QOS_CTL_PS_LEVEL      0x0200
>
> That looks like it could use a better name?

Do you mean something like IEEE80211_QOS_CTL_MESH_POWER_SAVE_LEVEL?
The first half is similar to previous constants.

Thanks,
Ivan
