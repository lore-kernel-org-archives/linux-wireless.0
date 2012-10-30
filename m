Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62559 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab2J3WWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 18:22:48 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so314484eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2012 15:22:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <508EB783.9080000@candelatech.com>
References: <508EB783.9080000@candelatech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 31 Oct 2012 09:22:27 +1100
Message-ID: <CAGRGNgWGfL+_u4fHEfqZAcFHb1H4Z4jFkiE4qKLU6i9XEWzZ6w@mail.gmail.com> (sfid-20121030_232254_070608_F09737F0)
Subject: Re: Any thoughts on how to best shield u.fl connectors on NICs?
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Tue, Oct 30, 2012 at 4:06 AM, Ben Greear <greearb@candelatech.com> wrote:
> It appears hard to get well-shielded u.fl (IPEX) to SMA pigtails, and all of
> the
> modern ath9k NICs I've seen use u.fl connectors on the NIC.
>
> I have found a vendor that will do double-shielded 1.32mm cable, and I have
> some of those
> on order, but the way u.fl connectors are made it seems there is always a
> bit of un-shielded
> cable where the connector is crimped onto the cable.
>
> I am curious if anyone has any suggestions or experience with connecting
> u.fl NICs to
> SMA cables in a highly shielded manner...

I have an awful feeling that it's simply not going to happen - I would
guess from what you've described that the u.fl connector is designed
to be cheap, small and easy and not really designed for "real" work
like what you're doing with it. I'm guessing that the signal leakage
through the connector is probably not a problem for the manufacturers
as they're always shielded inside a computer case - i.e. it complies
with the FCC rules.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
