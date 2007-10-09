Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:25763 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbXJIP7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 11:59:18 -0400
Received: by py-out-1112.google.com with SMTP id u77so3130474pyb
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2007 08:59:17 -0700 (PDT)
Message-ID: <43e72e890710090859i4a943e79u4521d65a6ddba1e7@mail.gmail.com> (sfid-20071009_165920_694504_72F619AF)
Date: Tue, 9 Oct 2007 11:59:17 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/6] ath5k: Enable radar detection
Cc: "Holger Schurig" <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1191922471.4013.24.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071006010449.GA25022@pogo> <20071008203415.GA7633@pogo>
	 <470A9EB1.4030706@apprion.com>
	 <200710090905.44641.hs4233@mail.mn-solutions.de>
	 <1191922471.4013.24.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/9/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2007-10-09 at 09:05 +0200, Holger Schurig wrote:
> > > There's an airport less
> > > than 1 mile away and I've never detected true radar.
> >
> > Maybe you need to go to some russian military camp. Some russian
> > surface-to-air missile systems used (20 years ago) frequency
> > ranges in the 5 GHz area.
>
> Indeed, I'm told most radars use 10GHz these days.

We'll just disable the filter for radar for now then and leave this
for later when someone wants DFS. We have other things we can work on
instead.

  Luis
