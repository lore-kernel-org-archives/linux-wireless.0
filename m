Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:58123 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440AbXIXU1H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 16:27:07 -0400
Received: by an-out-0708.google.com with SMTP id d31so246100and
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2007 13:27:07 -0700 (PDT)
Message-ID: <43e72e890709241327o2c1bcc7age4a438e42c9e4771@mail.gmail.com>
Date: Mon, 24 Sep 2007 16:27:07 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: Guide on how to submit patches for linux-wireless
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46F81281.7080407@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890709241209obc236eav5eca6c0828052ee1@mail.gmail.com>
	 <46F81281.7080407@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/24/07, Larry Finger <larry.finger@lwfinger.net> wrote:
> Luis R. Rodriguez wrote:
> > Here's a new guide to help developers write and submit patches
> > specifically for linux-wireless:
> >
> > http://linuxwireless.org/en/developers/SubmittingPatches
> >
>
> Very useful contribution.

Thanks.

> I have only two comments:

> (1) The pop-up above developers needs to be
> taller. The entry for 'Testing' overwrites the Developers tab on my machine, and

I've deleted testing from the navigation bar for now as that is an
incomplete doc.

> (2) patches,
> particularly large ones, need to be run through scripts/checkpatch.pl. It is better to find the
> "errors" yourself than have Andrew or Jeff point them out publicly.

Added, thanks.

  Luis
