Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53213 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbZJWOlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 10:41:42 -0400
Received: by bwz27 with SMTP id 27so940136bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2009 07:41:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910201413.29734.hs4233@mail.mn-solutions.de>
References: <200910201413.29734.hs4233@mail.mn-solutions.de>
Date: Fri, 23 Oct 2009 10:41:45 -0400
Message-ID: <b6c5339f0910230741v408fb734p37801e59be8e7d47@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: allow driver to signal noise level
From: Bob Copeland <me@bobcopeland.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 20, 2009 at 8:13 AM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
> Allows a WLAN driver to signal current noise level:
>

If the patch does survive in some form, can you change
the patch description to use "indicate" instead of
"signal?"  My internal parser kept searching for the
missing verb until I realized we were talking about
signalling the noise level instead of the signal [or]
noise level :)

-- 
Bob Copeland %% www.bobcopeland.com
