Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:49705 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967664AbaLLNWd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 08:22:33 -0500
Received: by mail-wi0-f179.google.com with SMTP id ex7so2560212wid.0
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2014 05:22:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418382458.2470.11.camel@sipsolutions.net>
References: <1418203400-6451-1-git-send-email-hrogge@gmail.com> <1418382458.2470.11.camel@sipsolutions.net>
From: Henning Rogge <hrogge@gmail.com>
Date: Fri, 12 Dec 2014 14:22:10 +0100
Message-ID: <CAGnRvuoBYBSKOwBitUU5RSirQzsJHvo=tj4N3BobgRp0OkT-+g@mail.gmail.com> (sfid-20141212_142236_860170_E146FF71)
Subject: Re: [PATCH] iw: Fix calculation of maximum supported 802.11n data rate
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

the bug was caught by Coverity (I use parts of the "iw" code in a
different project to talk to nl802.11).

Maybe it would be interesting to register the "iw" project with Coverity.

Henning

On Fri, Dec 12, 2014 at 12:07 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2014-12-10 at 10:23 +0100, Henning Rogge wrote:
>> Fix typo in calculation, binary AND combination of low byte
>> and high byte is always zero.
>
> Obviously - applied, thanks.
>
> johannes
>
