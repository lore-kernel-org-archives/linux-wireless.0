Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:48724 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762797AbZCXQNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 12:13:40 -0400
Received: by ewy9 with SMTP id 9so2148611ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 09:13:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237883293.6278.9.camel@johannes.local>
References: <20090323162834.154525349@sipsolutions.net> <1237883293.6278.9.camel@johannes.local>
Date: Tue, 24 Mar 2009 09:13:21 -0700
Message-ID: <43e72e890903240913iee51dcbnfa2409e01d4dd5c0@mail.gmail.com> (sfid-20090324_171347_567018_159914E9)
Subject: Re: [PATCH 0/8] mac80211 aggregation improvements
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 1:28 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-03-23 at 17:28 +0100, Johannes Berg wrote:
>
>> Here's my patch set for improving aggregation
>
> John, can I convince you to put this on track for .30 despite being
> posted just hours before the merge window officially opened? The reason
> I'm asking is that otherwise I'll have to support two code bases with
> rather different ways to have aggregation working for iwlwifi again,
> with different sets of bugs and different ways to fix it. This patch set
> has also been tested fairly extensively already [1] inside Intel for
> iwlwifi hardware and by Sujith for ath9k (and myself for both).

It is not accurate to say Sujith has extensively tested this for
ath9k, he probably just ran it a few times. So I cannot say we are as
comfortable with the patches as you or Intel seem to be already.

  Luis
