Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:44456 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbZEHSrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 14:47:07 -0400
Received: by ewy24 with SMTP id 24so2032281ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 08 May 2009 11:47:06 -0700 (PDT)
Date: Fri, 8 May 2009 21:46:57 +0300
From: Kadianakis George <desnacked@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: mac80211 and hidden ESSIDs in 2.6.28
Message-ID: <20090508184656.GB4529@grayskull>
References: <20090424180506.GA6026@grayskull> <20090508184135.GA4529@grayskull>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090508184135.GA4529@grayskull>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21:41 Fri 08 May     , Kadianakis George wrote:
> So, any ideas?
> Do you need any extra info?

Original post (http://marc.info/?l=linux-wireless&m=124059633132688&w=2):

Greetings,

this bug: http://bugs.gentoo.org/show_bug.cgi?id=262862 seems to
reveal a bug in mac80211 being unable to handle APs that don't
broadcast their ESSIDs.

The issue appeared in the 2.6.28 versions (2.6.27 worked alright) of
the Linux kernel and it seems to be fixed in 2.6.29.

A bugzilla entry for this specific bug was created over here:
http://bugs.gentoo.org/show_bug.cgi?id=267368

Any ideas on what caused it and which patch fixed it?

Thanks
