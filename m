Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46083 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1KDJKE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 05:10:04 -0400
Received: by ggnb2 with SMTP id b2so2285539ggn.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Nov 2011 02:10:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1320394336.3969.0.camel@jlt3.sipsolutions.net>
References: <CAMG6FYiNW-1ijghpgQ6R_9HujVEp8d53DQ-vjfJrw_hZamM8Jw@mail.gmail.com>
	<4EB33B67.6080806@lwfinger.net>
	<1320372088.29008.0.camel@dcbw.foobar.com>
	<CAMG6FYgD9DDa+eJgALi3LLF1yQO3ujaxAskpEf1kvcJ19rYwxA@mail.gmail.com>
	<1320394336.3969.0.camel@jlt3.sipsolutions.net>
Date: Fri, 4 Nov 2011 10:10:03 +0100
Message-ID: <CAMG6FYjGDhts2K3gYSeh0HACkFgSxxXZYdRCHrYp=2W3LceoyQ@mail.gmail.com> (sfid-20111104_101021_279775_794626CD)
Subject: Re: A new driver is going to be released
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>> Correct. But I would move it to drivers/net/wireless during submission.
>
> A word of caution: don't attempt that in its current state.
>
Thank you for caution. CONFIG_CW1200_USE_STE_EXTENSIONS,
CONFIG_WAKELOCK and HAS_PUT_TASK_STRUCT will be removed
of course, API will be aligned with 3.1. But I'm a bit curious what else could
prevent from submission to drivers/net/wireless? I do not see obvious problems
with code. Could you please give a short advise what should be fixed then if you
see problems?

Thank you and with best regards,
Dmitry
