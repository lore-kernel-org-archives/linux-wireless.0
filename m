Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:37331 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbcAGRAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 12:00:07 -0500
Received: by mail-ig0-f181.google.com with SMTP id h5so18393887igh.0
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2016 09:00:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzY+Me1ocZQYPtw83Wa_0ti+eOiOf1d1srHqtf_nsu-ON9w@mail.gmail.com>
References: <CALnQHM3C=DVaTf58XDyh+rttVs-FSpc4ghozg9HJktEonq7w-g@mail.gmail.com>
	<568E913D.7050301@candelatech.com>
	<CALnQHM1mzqFbprQqujB7BWncOa=D9uAxLQ0paiv-21vrx+hFvw@mail.gmail.com>
	<CABPxzYKaMPY6bz=Nr+W2wG5y_bV_wFN=7AMNUNcZNJBeVyYVJA@mail.gmail.com>
	<CALnQHM3O6Z3E2wSkVLirDHCdT8vQqvQbqVEcSs8mfsfGs9KFyg@mail.gmail.com>
	<CABPxzY+Me1ocZQYPtw83Wa_0ti+eOiOf1d1srHqtf_nsu-ON9w@mail.gmail.com>
Date: Thu, 7 Jan 2016 10:00:06 -0700
Message-ID: <CALnQHM1991akQy7_Ze-VzWJ7QBoe3cOwneL0pdufdUYEBjYKZw@mail.gmail.com> (sfid-20160107_180011_115452_F5441FA8)
Subject: Re: lost connectivity until "wpa_cli reassociate" is issued
From: David Mosberger <davidm@egauge.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 7, 2016 at 9:58 AM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:

> We can check pending packets per queue at mac80211, but first
> we need some info from driver level. Someone familiar with RTL
> should help.
>
> cat /sys/kernel/debug/ieee80211/phy*/queues
>
> If you see non-zero packets here (or) if the queue is stopped
> that might explain this behavior...

Cool.  I'll check that next time it happens, thanks!

  --david
-- 
eGauge Systems LLC, http://egauge.net/, 1.877-EGAUGE1, fax 720.545.9768
