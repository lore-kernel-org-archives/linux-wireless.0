Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49879 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab1LPTEn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 14:04:43 -0500
Received: by vbbfc26 with SMTP id fc26so2717165vbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Dec 2011 11:04:43 -0800 (PST)
Message-ID: <4EEB9647.9080208@lwfinger.net> (sfid-20111216_200446_984090_78EA68DF)
Date: Fri, 16 Dec 2011 13:04:39 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: Rearranging functions in phy_n.c
References: <CACna6rxEyGbxq813UW8RvzaysCd0jCawYZ0G6eN7XiAQOykTig@mail.gmail.com>
In-Reply-To: <CACna6rxEyGbxq813UW8RvzaysCd0jCawYZ0G6eN7XiAQOykTig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2011 12:55 PM, Rafał Miłecki wrote:
> Hey,
>
> The order of functions in phy_n.c is really messy. I wanted to collect
> related functions, fix order (dependency) and name goups via comments.
>
> Is there anything I should know? Patches are going to be huge, tons of
> lines moved around the phy_n.c :(
>
> Are there any objections against that? Any suggestions if I should
> post one huge patch or few smaller ones?

Several smaller ones always help the reviewer. I would vote for that option.

Larry

