Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43495 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab1I0MZz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 08:25:55 -0400
Received: by yxl31 with SMTP id 31so5244047yxl.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 05:25:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmonVHyv0dqApO+0xyP=AfgmEHzG=fxb-rr69CVo21k1btw@mail.gmail.com>
References: <20110922154726.521122680@sipsolutions.net>
	<20110922154849.369194760@sipsolutions.net>
	<CAB=NE6UP9xYmLY3nJRMVdjPky87hB1YzFTHEzBv0Pt=qv3kAmg@mail.gmail.com>
	<CAJ-Vmo=9MUaKph=EXwF2VnE+=nHg4s=j=qhR2jnwa-xsXMno7g@mail.gmail.com>
	<1317109807.4082.4.camel@jlt3.sipsolutions.net>
	<CAJ-VmonVHyv0dqApO+0xyP=AfgmEHzG=fxb-rr69CVo21k1btw@mail.gmail.com>
Date: Tue, 27 Sep 2011 20:25:55 +0800
Message-ID: <CAJ-Vmo=GKq4_kvxBsZxibpdpw=2J8RAxaQEVUkcK+XQK0MNTPQ@mail.gmail.com> (sfid-20110927_142559_021447_A60E7FD7)
Subject: Re: [RFC 03/15] mac80211: also expire filtered frames
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. the host _hardware_ TX queue. (And software TX queue, I likely have
to pause that too.)

I'm specifically only porting over small chunks to begin with so I
don't get overwhelmed with what needs to be developed, debugged and
supported.


Adrian
