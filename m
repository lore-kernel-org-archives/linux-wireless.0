Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:12537 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZC3NWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 09:22:54 -0400
Received: by yx-out-2324.google.com with SMTP id 31so1965585yxl.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 06:22:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49D0B7C2.1080701@gmail.com>
References: <1238414729-29358-1-git-send-email-me@bobcopeland.com>
	 <49D0B7C2.1080701@gmail.com>
Date: Mon, 30 Mar 2009 09:22:51 -0400
Message-ID: <b6c5339f0903300622m69402bdbl1d338af4c67f7113@mail.gmail.com> (sfid-20090330_152257_022834_4EEB7E1A)
Subject: Re: [PATCH] ath5k: reduce exported channel list
From: Bob Copeland <me@bobcopeland.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, mickflemm@gmail.com,
	lrodriguez@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 30, 2009 at 8:14 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> +static int modparam_all_channels;
>> +module_param_named(all_channels, modparam_all_channels, int, 0444);
>
> Make it bool and use S_* constants for perms, please (S_IRUGO). Maybe do
> it as a followup also cleaning up the former one.

Ok, I'll do it as a follow-up if John doesn't mind.

-- 
Bob Copeland %% www.bobcopeland.com
