Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:45581 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaIKKni (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 06:43:38 -0400
Received: by mail-qa0-f47.google.com with SMTP id dc16so55910qab.20
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2014 03:43:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1410430692.22863.2.camel@jlt4.sipsolutions.net>
References: <1409922404-8217-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1409922404-8217-2-git-send-email-henning.rogge@fkie.fraunhofer.de> <1410430692.22863.2.camel@jlt4.sipsolutions.net>
From: Henning Rogge <hrogge@gmail.com>
Date: Thu, 11 Sep 2014 12:43:17 +0200
Message-ID: <CAGnRvuovr_POseervRNz3hRU3DSJ+pe5iYrL=4xc5BnjsQEDKA@mail.gmail.com> (sfid-20140911_124342_313130_E43EB1E4)
Subject: Re: [PATCH v3 1/2] cfg80211: add ops to query mesh proxy path table
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 11, 2014 at 12:18 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2014-09-05 at 15:06 +0200, Henning Rogge wrote:
>> Add two new cfg80211 operations for querying the content of the the mac80211s proxy path table
>
> Please use shorter line lengths,

"git send-email" does not wrap the commit messages (first time to send
a patch like this for me)?

> and formulate it in a generic way - this shouldn't be mac80211 specific.

I will try...

Henning Rogge
