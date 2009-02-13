Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:54513 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZBMHJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 02:09:40 -0500
Received: by gxk22 with SMTP id 22so510987gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 23:09:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234508187.1327.19.camel@johannes.local>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-4-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-5-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-6-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-7-git-send-email-lrodriguez@atheros.com>
	 <1234508187.1327.19.camel@johannes.local>
Date: Thu, 12 Feb 2009 23:09:38 -0800
Message-ID: <43e72e890902122309q61036a23k2efeb14fe3a6e814@mail.gmail.com> (sfid-20090213_080943_180672_71B96E3A)
Subject: Re: [PATCH 6/6] cfg80211: move regulatory hints to workqueue
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 10:56 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-02-12 at 21:36 -0800, Luis R. Rodriguez wrote:
>> Driver and userspace regulatory hints are now processed in
>> a workqueue. This should fix some lockdep warnings which complain
>> about possible circular locking dependencies such as:
>
> Yes, but I need to look at the one Reinette posted and fix that one,
> which will probably require a different solution.

Oh I didn't see that one. How different?

  Luis
