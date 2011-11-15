Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dy0-f46.google.com ([209.85.220.46]:47868 "EHLO
	mail-dy0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab1KOT3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 14:29:19 -0500
Received: by dyi18 with SMTP id 18so309608dyi.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2011 11:29:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321384334.3975.2.camel@jlt3.sipsolutions.net>
References: <1321371888-26897-1-git-send-email-patrick.kelle81@gmail.com>
	<CAA93jw7nWHnCnT48RJ00+Zxq9CFuCzhkeh=+7h+DqvYH2T7W1Q@mail.gmail.com>
	<1321384334.3975.2.camel@jlt3.sipsolutions.net>
Date: Tue, 15 Nov 2011 20:29:17 +0100
Message-ID: <CAA93jw56rVGCJfx+7niRJ0whUk3c1H8o228dkOTcoi5agXZF_A@mail.gmail.com> (sfid-20111115_202923_513080_3FAEA9B1)
Subject: Re: [PATCH] minstrel_ht: Remove unused function parameters
From: Dave Taht <dave.taht@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Patrick Kelle <patrick.kelle81@gmail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 15, 2011 at 8:12 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-11-15 at 20:10 +0100, Dave Taht wrote:
>> It was kind of my hope that one day minstrel would export a useful API
>> and statistics to other subsystems - like sysfs, tc or the upper parts of the
>> network stack, and snmp.
>
> I think that doesn't make a lot of sense -- it should be done at a more
> abstract level.

what was the intent of parameter being removed in this patch series,
originally, then?

> johannes
>
>



-- 
Dave Täht
SKYPE: davetaht
US Tel: 1-239-829-5608
FR Tel: 0638645374
http://www.bufferbloat.net
