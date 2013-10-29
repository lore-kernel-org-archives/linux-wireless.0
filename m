Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:61563 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3J2XLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 19:11:11 -0400
Received: by mail-la0-f46.google.com with SMTP id hp15so465289lab.33
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 16:11:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1383087091.12439.33.camel@joe-AO722>
References: <1383086346-2096-1-git-send-email-mcgrof@do-not-panic.com>
 <1383086346-2096-4-git-send-email-mcgrof@do-not-panic.com> <1383087091.12439.33.camel@joe-AO722>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 30 Oct 2013 00:10:49 +0100
Message-ID: <CAB=NE6UeP4CvR+rwGvrLXcy6a-y=dYq915Pqz_Dw7tDHPYXB2Q@mail.gmail.com> (sfid-20131030_001129_358488_8A0FDC77)
Subject: Re: [PATCH 3/3] ath: fix dynamic user regulatory domain support
To: Joe Perches <joe@perches.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 29, 2013 at 11:51 PM, Joe Perches <joe@perches.com> wrote:
> Missing break?

Bug, that's what I get for working until midnight, I should know
better to balance my work.... damn it. Thanks for the review.

  Luis
