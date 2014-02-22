Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:51378 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaBVAbg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 19:31:36 -0500
Received: by mail-la0-f54.google.com with SMTP id y1so3035906lam.27
        for <linux-wireless@vger.kernel.org>; Fri, 21 Feb 2014 16:31:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALhHN=qaD=WPxN=SUBiB0yWVMi3Tugsug6uDkjiiSJyCbVOeCA@mail.gmail.com>
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
 <1392807806.4733.14.camel@jlt4.sipsolutions.net> <CALhHN=rAT=FeEJcbDJEPG+-knGgMvV8Mt5eVvWRWD-1BgZYLpQ@mail.gmail.com>
 <1392809288.4733.15.camel@jlt4.sipsolutions.net> <CAB=NE6WDvxXGT21H5-D4H3tSJ_iZufp6X05_quPpoAeaoMkOog@mail.gmail.com>
 <CALhHN=qaD=WPxN=SUBiB0yWVMi3Tugsug6uDkjiiSJyCbVOeCA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 21 Feb 2014 16:31:14 -0800
Message-ID: <CAB=NE6UV6QdAK-hz738KHg19KezBzSEun0Zz0zsiDuOnVecj-w@mail.gmail.com> (sfid-20140222_013139_121536_A5066E23)
Subject: Re: [PATCH 1/4] cfg80211: regulatory, introduce DFS CAC time
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 11:12 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> We can allow VERSION=19 and VERSION=20, and handle this in CRDA
> dynamically. This should be quite easy.

My point was what about older versions of CRDA that get a new
wireless-regdb tossed onto the system?

  Luis
