Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:47065 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbbBTRWG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 12:22:06 -0500
Received: by wevm14 with SMTP id m14so6775097wev.13
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2015 09:22:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20150220T175341-637@post.gmane.org>
References: <1424443813-13634-1-git-send-email-ap420073@gmail.com>
	<loom.20150220T175341-637@post.gmane.org>
Date: Sat, 21 Feb 2015 02:22:04 +0900
Message-ID: <CAMArcTUCnxNY-cmDNSttOoBvQ1S35OeYQR6eAz5Aghe6cTto2Q@mail.gmail.com> (sfid-20150220_182211_479863_984B851F)
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Fix some beacon issue
From: "ap420073 ." <ap420073@gmail.com>
To: Mike Turner <miketurner.forum@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-02-21 1:58 GMT+09:00 Mike Turner <miketurner.forum@gmail.com>:
>
> Taehee Yoo <ap420073@...> writes:
>
> >
> > Sometimes rtl8192cu is not sending beacon frame.
> > This patch fix this issue.
> >
> > Signed-off-by: Taehee Yoo <ap420073@...>
>
>
>
> Tried this and it doesn't help. Beacon transmission still isn't
> consistent. Can hostapd have an effect on this?
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



can you tell me hostapd options and detailed situation?
