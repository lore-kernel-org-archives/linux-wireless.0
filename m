Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:44285 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbbA3GPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 01:15:50 -0500
Received: by mail-la0-f46.google.com with SMTP id s18so22074147lam.5
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jan 2015 22:15:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422543484.6322.10.camel@sipsolutions.net>
References: <1392060043.4128.37.camel@jlt4.sipsolutions.net>
	<1422543484.6322.10.camel@sipsolutions.net>
Date: Fri, 30 Jan 2015 07:15:49 +0100
Message-ID: <CACna6rzvhJGgQNWBZvfTSz4bsFRsTPcZNiKoZ+po==u6K8gEEg@mail.gmail.com> (sfid-20150130_071556_664850_B6716550)
Subject: Re: moving the wiki
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 January 2015 at 15:58, Johannes Berg <johannes@sipsolutions.net> wrote:
>> Obviously, another consequence is that the wiki markup will change
>> somewhat. Moin and Mediawiki aren't too far from each other (except for
>> table syntax), but there are some things that are different that you'll
>> have to get used to when editing.
>
> Again, dokuwiki - slightly different from moinmoin.

Tables using colspans were not moved correctly, see e.g.:
https://wireless.wiki.kernel.org/en/users/Drivers/b43/soc

It displays "–colspan=3–Chip" in a table cell.

-- 
Rafał
