Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37243 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1EYEjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2011 00:39:22 -0400
Received: by ywe9 with SMTP id 9so2710254ywe.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 21:39:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201105250624.32360.helmut.schaa@googlemail.com>
References: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com>
	<1105241841310.6936@somehost>
	<4DDBE538.1090902@gnu.org>
	<201105250624.32360.helmut.schaa@googlemail.com>
Date: Wed, 25 May 2011 12:39:21 +0800
Message-ID: <BANLkTimONUfBqMv6N794me9UGMjU5Ue7rA@mail.gmail.com> (sfid-20110525_063928_612515_414A6AC4)
Subject: Re: Initial automatic channel selection implementation
From: Adrian Chadd <adrian@freebsd.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Pavel Roskin <proski@gnu.org>,
	Cristian Ionescu-Idbohrn <cristian.ionescu-idbohrn@axis.com>,
	hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 May 2011 12:24, Helmut Schaa <helmut.schaa@googlemail.com> wrote:

>> It's possible that the list of autoselectable channels could be country
>> specific.  I would hate to add complexity to CRDA.  Hopefully we could
>> device a simple algorithm to find the autoselectable channels based on
>> the CRDA data.
>
> Why not use a channel list as input to the algorithm (in whatever form).
> Hence, it would work for all channels (if the user wishes to do so) but it
> can be limited to a list of preferred channels (1,6,11).

FreeBSD's net80211 seems to do something like this in hostap mode. Has
anyone investigated it?

I ask because I'm about to port channel statistics (survey, ext
channel info) to net80211 in FreeBSD so it can be used in channel
selection and survey feedback.


Adrian
