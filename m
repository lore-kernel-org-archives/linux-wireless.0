Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34471 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab1K1Pok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 10:44:40 -0500
Received: by eaak14 with SMTP id k14so1920856eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 07:44:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322469030.4060.4.camel@jlt3.sipsolutions.net>
References: <1322432153-17425-1-git-send-email-mar.kolya@gmail.com>
	<1322469030.4060.4.camel@jlt3.sipsolutions.net>
Date: Mon, 28 Nov 2011 10:44:38 -0500
Message-ID: <CALGY4ftDBArahTTQAoy07Q+qjR2UtXJ7KETPk-rR33u+f0Radw@mail.gmail.com> (sfid-20111128_164854_725341_05337D82)
Subject: Re: [PATCH 0/2] mac80211: use timeout from addba resp
From: Nikolay Martynov <mar.kolya@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

2011/11/28 Johannes Berg <johannes@sipsolutions.net>:
> On Sun, 2011-11-27 at 17:15 -0500, Nikolay Martynov wrote:
>> If other side sent us non zero timeout in addba response use it as a
>> timeout for TX session. Before this patch initiator and recipient
>> could have different timeouts if recipient decides to change timeout
>> offered by initiator.
>
> I'm not convinced this is correct, can you say where the standard says
> that we should take the recipient's timeout? The way I read it, the
> originator informs the recipient of its timeout, not the other way
> around, and we implement that in agg-rx.

 Sorry, about this. I just though that if addba resp contains timeout
then there should be some use of it. If this goes against standard
just disregard this patch.
 BTW, is it possible to download a copy of the standard or is it
something I need to pay for/subscribe to?
 Thanks!


-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
