Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:48012 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbYIPCJO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 22:09:14 -0400
Received: by gxk9 with SMTP id 9so26408195gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 19:09:13 -0700 (PDT)
Message-ID: <43e72e890809151909j5100e0e7l8fb93bfc29b3096b@mail.gmail.com> (sfid-20080916_040917_115922_96E9FCC5)
Date: Mon, 15 Sep 2008 19:09:13 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [RFC] mac80211: re-enable aggregation on 2.6.27
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890809151709k7a2fc3bei6e420db7765063a4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1221503192-28502-1-git-send-email-lrodriguez@atheros.com>
	 <43e72e890809151555u3a79bd89h763fa0a6ba07e752@mail.gmail.com>
	 <43e72e890809151624g3540f308r90808e281b22314e@mail.gmail.com>
	 <1ba2fa240809151705k5b868c88j9151f04e485b542a@mail.gmail.com>
	 <43e72e890809151709k7a2fc3bei6e420db7765063a4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 15, 2008 at 5:09 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Mon, Sep 15, 2008 at 5:05 PM, Tomas Winkler <tomasw@gmail.com> wrote:

>> Are you sure there is aggregation on the air? In 40Mhz with
>> aggregation we should be at least 110Mbit or better something around
>> 150Mbits. This looks like HT rates but no aggregation.
>
> I'll ask wireshark.

Meh, tshask is only letting me see the block acks @ 24 Mbit/s, I don't
see the data frames.

  Luis
