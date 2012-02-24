Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40141 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab2BXRnJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 12:43:09 -0500
Received: by ggnh1 with SMTP id h1so1267679ggn.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2012 09:43:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+yqC4buizhVjtWMTSfaD2c8d+cLjn13a-H2Ez883gxy8K8j+g@mail.gmail.com>
References: <CA+yqC4buizhVjtWMTSfaD2c8d+cLjn13a-H2Ez883gxy8K8j+g@mail.gmail.com>
Date: Fri, 24 Feb 2012 09:43:08 -0800
Message-ID: <CAMcMvsj2XMFarr1+fqdSv88ZLrXLquK7wgF8LsTYDBfvHFwgrA@mail.gmail.com> (sfid-20120224_184316_066550_7B13BF0D)
Subject: Re: [RFC] mac80211: Filter duplicate IE ids [corrupted beacons]
From: Paul Stewart <pstew@chromium.org>
To: Sam Leffler <sleffler@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 24, 2012 at 9:31 AM, Sam Leffler <sleffler@google.com> wrote:
> On Fri, Feb 24, 2012 at 7:43 AM, Paul Stewart <pstew@chromium.org> wrote:
>
>> If my over-the-air captures are any indication, with some probability
>> you will receive a corrupted beacon from time to time -- perhaps not
>> due to a broken AP, but just from it being corrupted over the air.
>> FCS could catch that most times, but perhaps sometimes not.
>
> I can't recall ever receiving a "corrupted frame" that passed FCS and
> wasn't delivered due to some driver/hw problem.

Fair point.  I still think flag clearing is still useful if the user
finally goes over and kicks the AP into working correctly again.

> -Sam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
