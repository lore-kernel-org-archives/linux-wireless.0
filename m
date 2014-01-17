Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:48206 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaAQTDc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 14:03:32 -0500
Received: by mail-wg0-f47.google.com with SMTP id m15so4933179wgh.14
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 11:03:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389984919.10404.7.camel@jlt4.sipsolutions.net>
References: <1389909758-6807-1-git-send-email-chaitanya.mgit@gmail.com> <1389984919.10404.7.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sat, 18 Jan 2014 00:33:10 +0530
Message-ID: <CABPxzYJU+Ws4di0jLBM4pBc-mcQfjKgnZ28nsx-Bky5mB9QvcA@mail.gmail.com> (sfid-20140117_200347_506880_70F89A06)
Subject: Re: [PATCH] cfg80211: Do not call CRDA when using internal regulatory database
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 18, 2014 at 12:25 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2014-01-17 at 03:32 +0530, Chaitanya T K wrote:
>> When using internal regulatory data base kconfig option
>> do not try to call crda, this complely defeats the
>> purposes of enabling internal regulatory db.
>
> In general I don't think you can just break user visible behaviour this
> way.
Well, users are habituated the wrong way :-). Any new user seeing the
internal_regdb might just forget about CRDA and face problems, in case
the DB is different in both.

How should we go about it, then?
