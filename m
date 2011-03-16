Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58559 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab1CPJvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 05:51:45 -0400
Received: by iyb26 with SMTP id 26so1484003iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 02:51:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=r-iktQVn8b1=iCh0PFDDP=mSVBUeqBfxa5e_B@mail.gmail.com>
References: <1300268390.3761.14.camel@jlt3.sipsolutions.net> <AANLkTi=r-iktQVn8b1=iCh0PFDDP=mSVBUeqBfxa5e_B@mail.gmail.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 16 Mar 2011 02:51:25 -0700
Message-ID: <AANLkTinH1DykLDu5=Sd+p-PugEC1bOayG=ojaAscJKBB@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix comment regarding aggregation buf_size
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That last line should really be:

>> + *     Note that the following is also illegal because it will violate buffering assumptions if frame 1 is lost again
>> + *      - TX:         189.....
>
> Dan
>
