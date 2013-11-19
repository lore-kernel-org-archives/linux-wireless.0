Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:43657 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3KSPT5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 10:19:57 -0500
Received: by mail-la0-f41.google.com with SMTP id eo20so119567lab.14
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 07:19:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1384871747.15364.6.camel@jlt4.sipsolutions.net>
References: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
	<1384794409-11211-1-git-send-email-egrumbach@gmail.com>
	<1384794409-11211-5-git-send-email-egrumbach@gmail.com>
	<1384871747.15364.6.camel@jlt4.sipsolutions.net>
Date: Tue, 19 Nov 2013 17:19:56 +0200
Message-ID: <CANUX_P2JkFTiVf95kipe8wpfQim1hY5NHsJUaOJEOtE994cZAw@mail.gmail.com> (sfid-20131119_162000_844145_FCD40A0A)
Subject: Re: [PATCH RESEND 5/5] cfg80211: Aggregate mgmt_tx parameters and fix
 channel setting
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach
egrumbach@gmail.com


On Tue, Nov 19, 2013 at 4:35 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-11-18 at 19:06 +0200, Emmanuel Grumbach wrote:
>> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
>>
>> Change cfg80211 and mac80211 to use cfg80211_mgmt_tx_params
>> struct to aggregate parameters for mgmt_tx functions.
>> This makes the functions' signatures less clumsy and allows
>> less painful parameters extension.
>
> Also, technically, this broke a whole bunch of drivers - I'll fix it.
>
oh well....
Thanks:)
