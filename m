Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42056 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2IGRFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 13:05:24 -0400
Received: by eaac11 with SMTP id c11so1002587eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2012 10:05:23 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH v3] p54: connect to 11w protected networks
Date: Fri, 7 Sep 2012 19:05:16 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <j@w1.fi>
References: <E1TA0re-00059m-CD@debian64.localnet> <1347036664.8913.1.camel@dcbw.foobar.com>
In-Reply-To: <1347036664.8913.1.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201209071905.16432.chunkeey@googlemail.com> (sfid-20120907_190528_558094_8570F378)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 September 2012 18:51:04 Dan Williams wrote:
> On Tue, 2012-09-04 at 15:19 +0200, Christian Lamparter wrote:
> > Previously, it was not possible to connect
> > to networks which requires 11w to be supported
> > by the stations.
> 
> If at all possible if we can do this without module parameters, that
> would be great.
Hm, just a odd question. How does 11w work with
TDLS and networks with mandatory 11w. So what
happens if a station with 11w wants to connect
to a station without over TDLS? So, do we need
to have a MFP flag at a per-station level, or
is it enough if we have it per-vif?

Regards,
	Chr
