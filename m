Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62555 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab0DZSEh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 14:04:37 -0400
Received: by mail-pw0-f46.google.com with SMTP id 9so8601955pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 11:04:37 -0700 (PDT)
Message-ID: <4BD5D5B1.6020906@lwfinger.net>
Date: Mon, 26 Apr 2010 13:04:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Michael Buesch <mb@bu3sch.de>, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] ssb: Avoid system hang when SPROM read fails
References: <4bd4c284.WBohOsmgdwRzw5JC%Larry.Finger@lwfinger.net> <20100426171505.GC2387@tuxdriver.com>
In-Reply-To: <20100426171505.GC2387@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/2010 12:15 PM, John W. Linville wrote:
> 
> Well, the "good" news is that I hit the "Unable to read SPROM" case.
> The bad news is that the box still hangs after the -ENODEV.  I have
> not yet tracked-down the exact location of the current hang.
> 
> John
> 
> P.S.  Sorry about the 'radio silence' -- I've been distracted with
> some other things.  Also, the box in question originally belonged
> to someone else who had configured it in a way that was less than
> friendly to kernel development.  I finally reinstalled it...

That box is certainly resistant!

I certainly understand your distractions. That has to be a major
understatement.

As the patch makes some improvement in both your system and the one in
Bug #15825, I'll push it as a real patch.

Would your box be available to me as a loaner? I have considered buying
a netbook for debugging purposes, but I cannot quite justify the cost.
In addition, Murphy's law would make whatever one I bought work without
any problems.

Larry
