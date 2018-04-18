Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37160 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752255AbeDRU5p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 16:57:45 -0400
Message-ID: <1524085061.3024.8.camel@sipsolutions.net> (sfid-20180418_225749_244562_DB13137D)
Subject: Re: ath confusing log message "country IE"
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Bernhard Gabler <Bernhard_Gabler@web.de>,
        Linux-Wireless mailing list <linux-wireless@vger.kernel.org>
Date: Wed, 18 Apr 2018 22:57:41 +0200
In-Reply-To: <87o9ig1s3o.fsf@toke.dk> (sfid-20180418_165601_687010_B40C35D7)
References: <660b1538-0ccb-8f1a-ebe0-632b0e14a46b@web.de>
         <87o9ig1s3o.fsf@toke.dk> (sfid-20180418_165601_687010_B40C35D7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-04-18 at 16:55 +0200, Toke Høiland-Jørgensen wrote:
> 
> Heh, that is a good point, I think. The patch below should fix it; but I
> worry that the log lines become quite long, then? Maybe better to use
> "country-IE", but that could also be confused. "country inf.elem"
> perhaps?

Heh. Drop "information" entirely, the spec also did :-)

802.11-2016 just says

9.4.2 Elements
[...]
9.4.2.9 Country element

johannes
