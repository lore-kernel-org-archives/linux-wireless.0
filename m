Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51267 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab1JJUH0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 16:07:26 -0400
Received: by gyg10 with SMTP id 10so5704454gyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 13:07:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318277096.4001.1.camel@jlt3.sipsolutions.net>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	<1318234397-21081-7-git-send-email-eliad@wizery.com>
	<1318277096.4001.1.camel@jlt3.sipsolutions.net>
Date: Mon, 10 Oct 2011 22:07:25 +0200
Message-ID: <CAB3XZEd_YMQ=pkdyo_FkAD6ivsqhFR-S08EDNcCoWL6JKcvVJA@mail.gmail.com> (sfid-20111010_220735_165101_B09A732A)
Subject: Re: [PATCH 06/29] wl12xx: add vifs list
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 10, 2011 at 10:04 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-10-10 at 10:12 +0200, Eliad Peller wrote:
>> keep a list of all the vifs associated with our hw.
>> it will be later used in order to iterate through vifs.
>
> What's wrong with ieee80211_iterate_active_interfaces() :-)

defining iterator for each time we want to iterate is pretty cumbersome :)
