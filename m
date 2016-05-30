Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33193 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbcE3GEu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2016 02:04:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAGRGNgWYuEVnF7OG4GKJrnNNkn8DWaAor=ebbiwRbTZBP8qn5Q@mail.gmail.com>
References: <cover.1464576022.git.kirtika.ruchandani@gmail.com>
	<80c4512b4c5ca1f26ecda9785a456c4d0cf4f937.1464576022.git.kirtika.ruchandani@gmail.com>
	<CAGRGNgWYuEVnF7OG4GKJrnNNkn8DWaAor=ebbiwRbTZBP8qn5Q@mail.gmail.com>
Date: Sun, 29 May 2016 23:04:48 -0700
Message-ID: <CAA-b7a_X=-Nk0CUD4ayssKB6nzDF9e7iWwD2gandxar-G35ZzA@mail.gmail.com> (sfid-20160530_080457_124822_A5A56CDA)
Subject: Re: [PATCH v2 06/10] nl80211: Various checkpatch.pl spacing fixes
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Adding the brackets around the & expression doesn't look spacing
> related to me. What's the exact warning this is fixing?

>From the commit message - "This patch also contains two hunks to fix
'line over 80 characters',
that are spacing related". This is the second hunk, the first being
the comments in the nl80211_fam
definition. Should I resend with these two hunks omitted, or fix my wording?
