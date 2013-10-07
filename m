Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:59085 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3JGRvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 13:51:15 -0400
Received: by mail-lb0-f178.google.com with SMTP id z5so5769058lbh.23
        for <linux-wireless@vger.kernel.org>; Mon, 07 Oct 2013 10:51:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFSJ42YRmwZ-mK5yADsf=sfi7b5rEK9hFdH-waoswrubvyZddA@mail.gmail.com>
References: <1380234508-3121-1-git-send-email-k.eugene.e@gmail.com>
 <20131004234514.GA11128@garbanzo.do-not-panic.com> <CAFSJ42YRmwZ-mK5yADsf=sfi7b5rEK9hFdH-waoswrubvyZddA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 7 Oct 2013 10:50:54 -0700
Message-ID: <CAB=NE6UToY0zeuarb7f_aExCuxqmghCcmdRkxMSWR-CgGjRk6Q@mail.gmail.com> (sfid-20131007_195118_639867_822E18A7)
Subject: Re: [PATCH] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx <wcn36xx@lists.infradead.org>,
	wcn36xx <wcn36xx@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 6, 2013 at 12:30 PM, Eugene Krasnikov <k.eugene.e@gmail.com> wrote:
>> +static void wcn_reg_notifier(struct wiphy *wiphy,
>> +                            struct regulatory_request *request)
>> +{
>
> Function should be called wcn36xx_reg_notifier not wcn_reg_notifier.
> Could you please change that?

Feel free to make that change on your end :D

  Luis
