Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:39167 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaESOpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 10:45:55 -0400
Received: by mail-qc0-f172.google.com with SMTP id l6so9177340qcy.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 07:45:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140519142959.GB6198@localhost>
References: <CAGnRvurDvRqeNZYHZQG63=6FQv2XnFOR+J9K4-Dk=F77c6SdKQ@mail.gmail.com>
 <20140519131832.GA6198@localhost> <CAGnRvuq9pP3f+KiZAZ6Rpz-NKPqW9tnPRX4MmGZ6PK9PT3U_xA@mail.gmail.com>
 <20140519142959.GB6198@localhost>
From: Henning Rogge <hrogge@gmail.com>
Date: Mon, 19 May 2014 16:45:25 +0200
Message-ID: <CAGnRvuozBpvgW0i9AoOWOG2TkUeWxMzy5d1Kxz6m5AgxWadBNg@mail.gmail.com> (sfid-20140519_164559_203985_177B2E14)
Subject: Re: 802.11s mode without HWMP
To: Bob Copeland <me@bobcopeland.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 19, 2014 at 4:29 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Mon, May 19, 2014 at 04:14:36PM +0200, Henning Rogge wrote:
>> I want to force 802.11s only to connect to other stations one layer-2
>> hop away. So no forwarding by intermediate stations.
>>
>> Does the "mesh_fwding" parameter maybe help? Or can I set a "TTL" for
>> the PREQ messages to 1?
>
> Ah, ok got it.  Then yes, you are right, either of those approaches will
> disable forwarding.

I will try both of them and see what the Mac80211 Monitor mode sees.

But I have a second question, does the 802.11 mesh mode keep track
which "end to end" mac address is behind which "mesh" mac address? If
I bridge the mesh interfaces to an ethernet both will not be the same.

Henning Rogge
