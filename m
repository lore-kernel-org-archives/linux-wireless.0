Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:5596 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYI1QY2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 12:24:28 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1649886fkq.5
        for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2008 09:24:24 -0700 (PDT)
Message-ID: <1ba2fa240809280924n1505e049w7800e3ef28449e8e@mail.gmail.com> (sfid-20080928_182431_866190_1A7A533B)
Date: Sun, 28 Sep 2008 19:24:24 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: send action frame when toggling SM PS mode
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1222618769.7064.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222618493-19019-1-git-send-email-tomas.winkler@intel.com>
	 <1222618769.7064.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 28, 2008 at 7:19 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2008-09-28 at 19:14 +0300, Tomas Winkler wrote:
>> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>>
>> This patch makes mac80211 able to send action frames when toggling
>> (SM PS) Spacial Multiplexing Power Save mode.
>>
>> Example:
>> 1.
>> Low lever driver may close some of RX chains in power save mode
>> and needs to announce to AP that a RTS frame is need in order to wake all
>> RX chains, on other hand SM PS can be disabled on CAM mode or if HW is able
>> to wake all chains without RTS frame.
>>
>> 2.
>> iwlwifi can call this function when it detects that only
>> one antenna can effectively receive then MS PS mode is set to STATIC and
>> AP is asked not to send MIMO rates packets.
>
> Why is the driver managing the PS mode to start with?

What PS mode, SM PS mode or traditional PS mode? Please be more
verbose so I don't have to guess what you mean.
Thanks
Tomas
