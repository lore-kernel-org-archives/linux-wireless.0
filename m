Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:59987 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbaEGJGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 05:06:33 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so657387wes.41
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 02:06:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQnJ7N=UtDu_tySg8uYrQg9i+BvuYrwez7x-LUVinroWDw@mail.gmail.com>
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	<1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
	<1397051137-26201-3-git-send-email-michal.kazior@tieto.com>
	<1399387345.4218.44.camel@jlt4.sipsolutions.net>
	<CA+BoTQ=FqfB46Bd6iC3F=Ps=b4f6CP77p5d6f4fiVLUttCYQjg@mail.gmail.com>
	<1399449912.5038.7.camel@jlt4.sipsolutions.net>
	<CA+BoTQnJ7N=UtDu_tySg8uYrQg9i+BvuYrwez7x-LUVinroWDw@mail.gmail.com>
Date: Wed, 7 May 2014 11:06:31 +0200
Message-ID: <CA+BoTQ=-Y1r3L9S=3cLf9PnHY+KY6GhA62Q4xiT1NC4xOhQVnw@mail.gmail.com> (sfid-20140507_110636_735894_663D9E0A)
Subject: Re: [PATCH v4 2/5] mac80211: use chanctx reservation for AP CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 May 2014 11:05, Michal Kazior <michal.kazior@tieto.com> wrote:
[...]
> Real-world multi-vif CSA will probably be off by up to 1 or 2 beacon
> intervals between vifs which should be disruptive for clients I guess.

shouldn't (eh, proofreading)


Michał
