Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:56015 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074Ab1EILfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 07:35:03 -0400
Received: by mail-ew0-f43.google.com with SMTP id 20so2017676ewy.2
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 04:35:01 -0700 (PDT)
Subject: Re: [PATCH] mac80211: add a couple of trace event classes to
 reduce duplicated code
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1304940808.12202.0.camel@jlt3.sipsolutions.net>
References: <1304940469-4978-1-git-send-email-coelho@ti.com>
	 <1304940808.12202.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 14:34:58 +0300
Message-ID: <1304940898.12586.449.camel@cumari> (sfid-20110509_133506_135223_7498506E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-09 at 13:33 +0200, Johannes Berg wrote:
> On Mon, 2011-05-09 at 14:27 +0300, Luciano Coelho wrote:
> > The functions drv_add_interface() and drv_remove_interface() print out
> > the same values in the traces.  Combine the traces of these two
> > functions into one event class to remove some duplicate code.
> > 
> > Also add a new class for functions drv_set_frag_threshold() and
> > drv_set_rts_threshold().
> 
> Nice :)
> 
> 
> > +DECLARE_EVENT_CLASS(local_value_evt,
> 
> Though I wonder if that might be better as "local_u32_evt"?

Yeah, I thought about it too... I'll send v2.

-- 
Cheers,
Luca.

