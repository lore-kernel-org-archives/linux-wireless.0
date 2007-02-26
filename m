Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:47350 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbXBZJ04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Feb 2007 04:26:56 -0500
Received: by nf-out-0910.google.com with SMTP id o25so1688808nfa
        for <linux-wireless@vger.kernel.org>; Mon, 26 Feb 2007 01:26:55 -0800 (PST)
Message-ID: <a32f33a40702260126p29915160n10b8790b19f405aa@mail.gmail.com>
Date: Mon, 26 Feb 2007 10:26:55 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 3/3] d80211: Split antenna selection into TX and RX antenna
Cc: "Jiri Benc" <jbenc@suse.cz>, "Michael Buesch" <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070226011810.GC4936@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200702211702.48001.IvDoorn@gmail.com>
	 <20070223172815.359080e8@griffin.suse.cz>
	 <200702231739.04950.IvDoorn@gmail.com>
	 <20070226011810.GC4936@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Sorry about that, I had renamed rx_params to rx_status in my cvs tree and hadn't set that
> > correctly to the git tree yet. I'll try to update rt2x00 inside wireless-dev as soon as possible,
> > but in the mean time here is the correct patch.
>
> Since you brought it up... :-)
>
> It would be a big help if rt2x00 could keep upstream in-sync with your
> current developments.  FWIW, I expect wireless-dev to get picked-up
> in -mm soon, and Fedora has it in rawhide already.  So, it is in your
> own best interest to make sure that we have the latest fixes here,
> unless you want to support two different versions... :-)

True true, I am terribly late with updating rt2x00 in the wireless-dev tree. :(
I'll try to send several patches this week, I am not sure if that will be entire
update because some changes are quite big.
Although I should note that rt2x00 still isn't stable, rt61pci and rt73usb seem
to be problematic in the sense that they still fail to associate or
manage to associate
only for a second before being disassociated again. The other drivers
in rt2x00 also
show various problematic behavior with suspend/resume, running
ifconfig down followed
by ifconfig up, monitor mode that isn't picking up everything,
scanning that only picks
up the strongest signals (Even APs that are a few meters away are
sometimes not detected.) etc. etc.

Ivo
