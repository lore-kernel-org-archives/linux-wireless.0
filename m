Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0205.hostedemail.com ([216.40.44.205]:46188 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751275AbbEYSLU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 14:11:20 -0400
Message-ID: <1432577476.2846.68.camel@perches.com> (sfid-20150525_201139_201849_92F2A0F5)
Subject: Re: [PATCH] net:wireless - Change 1 to true for bool type variable.
From: Joe Perches <joe@perches.com>
To: Shailendra Verma <shailendra.capricorn@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 25 May 2015 11:11:16 -0700
In-Reply-To: <1432576544-3639-1-git-send-email-shailendra.capricorn@gmail.com>
References: <1432576544-3639-1-git-send-email-shailendra.capricorn@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-25 at 23:25 +0530, Shailendra Verma wrote:
> The variable translate is bool type.So assigning true instead of 1.

There are a lot these in the kernel.

$ git grep -P "^[ \t]*(?:static[ \t]+)?(?:const\s+)?bool\s+\w+\s*=\s*[01]\s*;" * | wc -l
161

Are you going to submit patches for all of them one at a time?

I suggest sending maybe 10 to 12 patches, one for each subsystem,
and cc the trivial maintainer Jiri Kosina <trivial@kernel.org>


