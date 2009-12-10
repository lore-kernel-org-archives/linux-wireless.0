Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52799 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbZLJNc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 08:32:26 -0500
Received: by bwz27 with SMTP id 27so6061607bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 10 Dec 2009 05:32:32 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: report non-zero bitrate for MCS rates through wext
References: <1260395165-7116-1-git-send-email-linville@tuxdriver.com>
	<871vj32mlm.fsf@purkki.valot.fi>
	<20091210130035.GB11112@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 10 Dec 2009 15:32:30 +0200
In-Reply-To: <20091210130035.GB11112@tuxdriver.com> (John W. Linville's message of "Thu\, 10 Dec 2009 08\:00\:36 -0500")
Message-ID: <87skbj0xap.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> On Thu, Dec 10, 2009 at 11:40:37AM +0200, Kalle Valo wrote:
>> "John W. Linville" <linville@tuxdriver.com> writes:
>> 
>> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> 
>> A small description in the commit log would be nice.

[...]

> What (beyond the subject) would you put in the commit log for this one?

How it affects me as an user? IMHO "non-zero bitrate for MCS" doesn't
tell that much and is a bit confusing. I would prefer something like
this:

  wireless: report 802.11n bitrates through wext

  cfg80211 reports all MCS rates (from 802.11n) as zero. Fix it by
  moving nl80211__calculate_bitrate() to cfg80211 and using it also
  with MCS rates.

But maybe I'm just weird :)

-- 
Kalle Valo
