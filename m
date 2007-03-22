Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.236]:64092 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030368AbXCVKtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2007 06:49:14 -0400
Received: by nz-out-0506.google.com with SMTP id s1so533168nze
        for <linux-wireless@vger.kernel.org>; Thu, 22 Mar 2007 03:49:14 -0700 (PDT)
Message-ID: <a32f33a40703220349u2addc4dfre0d31a941a4472d8@mail.gmail.com>
Date: Thu, 22 Mar 2007 11:49:08 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Prevent unregistering of unregistered hw
Cc: "Michael Buesch" <mb@bu3sch.de>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1174559874.3944.83.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200703091614.04526.IvDoorn@gmail.com>
	 <200703091646.05292.mb@bu3sch.de>
	 <200703091730.06796.IvDoorn@gmail.com>
	 <1174559874.3944.83.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Well it occurred in rt2x00 during errors during initialization,
> > instead of using goto's to step by step free all allocated memory and
> unregistration
> > the main free_dev() was called.
>
> Change that then, we like to see a proper error handling strategy that
> one can understand w/o checking all possible flags.

Ok will do that.

Ivo
