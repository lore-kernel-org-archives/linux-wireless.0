Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:61440 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaLVW0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2014 17:26:09 -0500
Received: by mail-ig0-f182.google.com with SMTP id hn15so4712262igb.3
        for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2014 14:26:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1419199788.2387.5.camel@sipsolutions.net>
References: <1419179546-29313-1-git-send-email-eliad@wizery.com>
	<1419179546-29313-2-git-send-email-eliad@wizery.com>
	<1419199788.2387.5.camel@sipsolutions.net>
Date: Tue, 23 Dec 2014 00:26:08 +0200
Message-ID: <CAB3XZEd7W-6kjESdy97=hx8NacXwnKGnc-KgtXSQKerMRgxC_w@mail.gmail.com> (sfid-20141222_232613_686159_D0093D13)
Subject: Re: [PATCH 2/2] mac80211: allow some multi-channel combinations with
 DFS master
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 22, 2014 at 12:09 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2014-12-21 at 18:32 +0200, Eliad Peller wrote:
>> Allow some multi-channel interface combinations along with
>> DFS master support, if there is only a single AP/GO.
>>
>> Allowing other interface types at the same time is fine
>
> I don't believe this to be true - how are you going to do radar
> detection accurately if you're spending any amount of time on another
> channel?
>
right. seems i was wrong here.
please drop this patch.

thanks,
Eliad.
