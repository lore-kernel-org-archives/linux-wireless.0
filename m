Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:43439 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaETBsY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 21:48:24 -0400
Received: by mail-ve0-f176.google.com with SMTP id jz11so7416548veb.35
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 18:48:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400498110-12879-1-git-send-email-michal.kazior@tieto.com>
References: <1400498110-12879-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 20 May 2014 09:48:23 +0800
Message-ID: <CAEFj985cRsbQozdoHb1-c1wkuKf79f06hEvtDxa-ufZyHJiHsA@mail.gmail.com> (sfid-20140520_034906_465507_5E7D65CF)
Subject: Re: [PATCH] ath10k: fix protected flag stripping
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 19, 2014 at 7:15 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> This prevents protected flag being stripped from
> undecrypted raw sniffed frames when monitor
> interface is active.
>
> Reported-by: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Tested-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Test and work. Thanks

---
Chun-Yeow
