Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57701 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2E2IjP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 04:39:15 -0400
Received: by obbtb18 with SMTP id tb18so6564439obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 01:39:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338275896.4342.28.camel@jlt3.sipsolutions.net>
References: <1336921624-5698-1-git-send-email-eliad@wizery.com>
	<1338275896.4342.28.camel@jlt3.sipsolutions.net>
Date: Tue, 29 May 2012 11:39:15 +0300
Message-ID: <CAB3XZEfvbuJszg6_Fm6pOW9ay6kubhn4oB580D+gpiTvcPx5RQ@mail.gmail.com> (sfid-20120529_103920_750300_E064B223)
Subject: Re: [PATCH] mac80211: fail authentication when AP denied authentication
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 29, 2012 at 10:18 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2012-05-13 at 18:07 +0300, Eliad Peller wrote:
>> ieee80211_rx_mgmt_auth() doesn't handle denied authentication
>> properly - it authenticates the station and waits for association
>> (for 5 seconds) instead of failing the authentication.
>>
>> Fix it by destroying auth_data and bailing out instead.
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>
> Cc: stable now that this code shipped in 3.4? (or didn't it?)
>
yep.
Cc: stable@vger.kernel.org #3.4
(John - i can resend if you prefer)

Eliad.
