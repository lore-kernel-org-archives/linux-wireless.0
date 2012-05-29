Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:45978 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753505Ab2E2OaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 10:30:04 -0400
Received: by obbwd20 with SMTP id wd20so8143134obb.4
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 07:30:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338275441.4342.20.camel@jlt3.sipsolutions.net>
References: <1337885569-32711-1-git-send-email-victorg@ti.com>
	<1338275441.4342.20.camel@jlt3.sipsolutions.net>
Date: Tue, 29 May 2012 17:30:03 +0300
Message-ID: <CAK80WHZxg4HgukVxuVLs6g0eJzq6t8_5YVa+cCM1KtnBY1gikQ@mail.gmail.com> (sfid-20120529_163009_220324_85C9B708)
Subject: Re: [PATCH 1/2] nl80211/cfg80211: add scan channel times to scan command
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 29, 2012 at 10:10 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> I think there may have to be some feature flag for this since otherwise
> you can't know whether you're going to be implementing 11k properly or
> not.

Will add it in v2.

-- 
Thanks,
Victor.
