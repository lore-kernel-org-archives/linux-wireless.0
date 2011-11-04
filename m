Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61298 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1KDOyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 10:54:08 -0400
Received: by ywf7 with SMTP id 7so2577279ywf.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Nov 2011 07:54:08 -0700 (PDT)
Message-ID: <4EB3FC8C.3010400@lwfinger.net> (sfid-20111104_155412_724511_CB648069)
Date: Fri, 04 Nov 2011 09:54:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: A new driver is going to be released
References: <CAMG6FYiNW-1ijghpgQ6R_9HujVEp8d53DQ-vjfJrw_hZamM8Jw@mail.gmail.com>  <4EB33B67.6080806@lwfinger.net> <1320372088.29008.0.camel@dcbw.foobar.com>
In-Reply-To: <1320372088.29008.0.camel@dcbw.foobar.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2011 09:01 PM, Dan Williams wrote:

> It looks like it's mac80211-based and already in drivers/staging/
> according to the git tree Dmitry pointed to.

A staging driver in a private tree is not the same as one in GregKH's staging 
tree. As this cw1200 driver has been seen by a limited number of developers, it 
needs to be submitted to staging in mainline before an attempt is made to 
convert it to the regular tree.

Larry

