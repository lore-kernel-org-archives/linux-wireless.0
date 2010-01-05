Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:50751 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab0AEQOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 11:14:51 -0500
Received: by iwn32 with SMTP id 32so896194iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2010 08:14:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e891001050813n5f5cd0bfp7e703902d3979158@mail.gmail.com>
References: <1262622502-27698-1-git-send-email-lrodriguez@atheros.com>
	<1262683554.20098.10.camel@johannes.local> <43e72e891001050813n5f5cd0bfp7e703902d3979158@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 5 Jan 2010 08:14:28 -0800
Message-ID: <43e72e891001050814t359807d9y2d7181df9790244c@mail.gmail.com>
Subject: Re: [RFC] cfg80211: add regulatory hint disconnect support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 5, 2010 at 8:13 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Jan 5, 2010 at 1:25 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>
>> However, I don't quite understand why we need this function. We already
>> tell cfg80211 about disconnect events or requests, can't it call some
>> regulatory update when either of those two happen?
>
> Sure, hence the RFC, can you point me to those events?

You mean the netlink ones we send to userspace?

  Luis
