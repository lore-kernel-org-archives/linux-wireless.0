Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f11.google.com ([209.85.217.11]:43350 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbYKFOxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 09:53:04 -0500
Received: by gxk4 with SMTP id 4so339881gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 06:53:01 -0800 (PST)
Message-ID: <1ba2fa240811060653y63a0fd51s7a57cea3c24211c7@mail.gmail.com> (sfid-20081106_155309_677526_0D75D627)
Date: Thu, 6 Nov 2008 16:53:00 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH/RFT] iwlagn: remove pointless TX frame check
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1225982711.3619.240.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1223547733.22490.43.camel@johannes.berg>
	 <1ba2fa240810091308r167b9147p46f74421329a55c1@mail.gmail.com>
	 <1223630089.3930.71.camel@johannes.berg>
	 <1224794532.6002.73.camel@johannes.berg>
	 <1225974603.3619.219.camel@johannes.berg>
	 <1ba2fa240811060641xe70c29cgf4e8dbf36b29636@mail.gmail.com>
	 <1225982711.3619.240.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 6, 2008 at 4:45 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2008-11-06 at 16:41 +0200, Tomas Winkler wrote:
>
>> I'm working on it right now. Practically instead of association check
>> what will  remain is check if everything is station is properly
>> configured. Meaning stations is configured in the set in the firmware
>> and rate scale is also set.
>
> That makes sense, though I think for frames we can't find the station we
> use the broadcast station anyway (to make injection possible), so
> shouldn't the station _always_ exist?

That's not the problem I'm trying to solve. I want to replace
association check, which ensure that two conditions are satisfied with
check for particular station including bcast station (bcast station is
just configured always a head)
Tomas
