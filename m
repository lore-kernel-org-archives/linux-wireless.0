Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34682 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbbJUMc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 08:32:28 -0400
Received: by wikq8 with SMTP id q8so91362086wik.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2015 05:32:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1445430474.4558.35.camel@sipsolutions.net>
References: <1445429499-22075-1-git-send-email-ola1olsson@gmail.com>
	<1445430474.4558.35.camel@sipsolutions.net>
Date: Wed, 21 Oct 2015 14:32:26 +0200
Message-ID: <CABAco3Ag6buvW1MX7ZWuYnAvPGz4YpiThU=8L6G5ooCB6aiARQ@mail.gmail.com> (sfid-20151021_143231_034547_DF4CCB81)
Subject: Re: [PATCH] iw: Print help text to "set bitrates" in case of no args
From: Ola Olsson <ola1olsson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ola Olsson <ola.olsson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I totally missed that. You are right!

/Ola

On Wed, Oct 21, 2015 at 2:27 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> This is incorrect - the help states:
>
> "Not passing any arguments would clear the existing mask (if any)."
>
> johannes
