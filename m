Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:50842 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYH2VcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 17:32:25 -0400
Received: by wr-out-0506.google.com with SMTP id 69so893717wri.5
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2008 14:32:25 -0700 (PDT)
Message-ID: <43e72e890808291432g1798e2e1ie6419011dfb1496d@mail.gmail.com> (sfid-20080829_233231_390749_47AE28E4)
Date: Fri, 29 Aug 2008 14:32:24 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 4/4 v2] cfg80211.h: add support for letting the user set the regulatory domain
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <200808292322.31719.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1220043811-9860-1-git-send-email-lrodriguez@atheros.com>
	 <200808292322.31719.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 29, 2008 at 2:22 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Friday 29 August 2008 23:03:31 Luis R. Rodriguez wrote:
>> +             .cmd = NL80211_CMD_REQ_SET_REG,
>> +             .doit = nl80211_ask_set_reg,
>
> Shouldn't we adjust the function name, too?

Heh.. yeah ok, good catch.

  Luis
