Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60440 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755349AbdJJNtE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 09:49:04 -0400
Message-ID: <1507643341.26041.61.camel@sipsolutions.net> (sfid-20171010_155030_844664_D7833210)
Subject: Re: [PATCH v2] mac80211: fix STA_SLOW_THRESHOLD htmldocs failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Cc: toke@toke.dk
Date: Tue, 10 Oct 2017 15:49:01 +0200
In-Reply-To: <20171010134107.GA3328@redhat.com>
References: <1506426485-7539-1-git-send-email-sgruszka@redhat.com>
         <20171010134107.GA3328@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-10 at 15:41 +0200, Stanislaw Gruszka wrote:
> On Tue, Sep 26, 2017 at 01:48:05PM +0200, Stanislaw Gruszka wrote:
> > Patch fixes htmldocs build problem:
> > 
> > Error(.//net/mac80211/sta_info.h:416): cannot understand prototype:
> > 'STA_SLOW_THRESHOLD 6000  '
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> > v1 -> v2: just fix documentation build, do not move the code.
> 
> Johannes, would you apply this? I think patch is safe to apply :-)

I already did :)

johannes
