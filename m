Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:34575 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030547AbXBOSy2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 13:54:28 -0500
Received: by ug-out-1314.google.com with SMTP id 44so260744uga
        for <linux-wireless@vger.kernel.org>; Thu, 15 Feb 2007 10:54:25 -0800 (PST)
Message-ID: <a32f33a40702151054p3b43bdedh8c372a5918e59e3f@mail.gmail.com>
Date: Thu, 15 Feb 2007 19:54:25 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] d80211: Add software sequence support
Cc: "Jiri Benc" <jbenc@suse.cz>, linux-wireless@vger.kernel.org
In-Reply-To: <20070215174143.GA6300@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200702141423.27823.IvDoorn@gmail.com>
	 <1171557724.5220.30.camel@johannes.berg>
	 <20070215174143.GA6300@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Then the driver can just call it whenever it needs the sequence number
> > for a frame. It'll need to be a bit smart about fragmentation but I
> > think that's ok.
> >
> > I may be radical, but I think that a lot of things hardware can do
> > belong into library functions the driver can use instead of cluttering
> > the stack with it.
>
> I'm inclined to agree, FWIW...

Ok, I'll change it. New patch will arrive in a few days.

Ivo
