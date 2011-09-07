Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63997 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1IGQdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 12:33:03 -0400
Received: by fxh19 with SMTP id 19so653368fxh.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 09:33:00 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH IGNORE AT YOUR PERIL] cfg80211: force interface combinations to be advertised
Date: Wed, 7 Sep 2011 18:32:48 +0200
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <1315412512.4002.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1315412512.4002.10.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201109071832.48120.chunkeey@googlemail.com> (sfid-20110907_183621_272527_8657B9A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, September 07, 2011 06:21:52 PM Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> So my "sunset" period idea didn't work, nobody
> worked on getting interface combinations added.
> Almost 4 months after introducing this flag, no
> drivers have been changed to advertise their
> interface combinations. Force them now if they
> want to keep multiple virtual interfaces.

no drivers? I thought I added the necessary bits
in carl9170 shortly after the interface combinations
patches were accepted?

commit df64962f7d74877624442c059e7878fdf7ec3c22
Author: Christian Lamparter <chunkeey@googlemail.com>
Date:   Sat May 14 02:42:38 2011 +0200

    carl9170: advertise interface combinations

Did I miss something there?

Regards,
	Chr
