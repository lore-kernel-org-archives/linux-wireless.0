Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45139 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1KDFc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 01:32:58 -0400
Received: by iage36 with SMTP id e36so2170158iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 22:32:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1320372088.29008.0.camel@dcbw.foobar.com>
References: <CAMG6FYiNW-1ijghpgQ6R_9HujVEp8d53DQ-vjfJrw_hZamM8Jw@mail.gmail.com>
	<4EB33B67.6080806@lwfinger.net>
	<1320372088.29008.0.camel@dcbw.foobar.com>
Date: Fri, 4 Nov 2011 06:32:57 +0100
Message-ID: <CAMG6FYgD9DDa+eJgALi3LLF1yQO3ujaxAskpEf1kvcJ19rYwxA@mail.gmail.com> (sfid-20111104_063306_997180_C17EC10D)
Subject: Re: A new driver is going to be released
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 4, 2011 at 3:01 AM, Dan Williams <dcbw@redhat.com> wrote:
> It looks like it's mac80211-based and already in drivers/staging/
> according to the git tree Dmitry pointed to.
>
Correct. But I would move it to drivers/net/wireless during submission.
