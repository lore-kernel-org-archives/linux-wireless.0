Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42938 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752206AbdC2JBb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 05:01:31 -0400
Message-ID: <1490778081.7948.17.camel@sipsolutions.net> (sfid-20170329_110255_239038_F6F4684C)
Subject: Re: [PATCH v3] cfg80211: add set/get link loss profile
From: Johannes Berg <johannes@sipsolutions.net>
To: "Lazar, Alexei Avshalom" <ailizaro@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
        wil6210@qca.qualcomm.com
Date: Wed, 29 Mar 2017 11:01:21 +0200
In-Reply-To: <62127d4a-db9f-ab77-fb86-17d92b0ce81d@codeaurora.org>
References: <7742335b-f05e-edcd-ad80-fd09fb295eab@codeaurora.org>
         <8737izqw0q.fsf@purkki.adurom.net>
         <b1ab1406-d996-fc03-d0a2-b8028c7c0044@codeaurora.org>
         <8737ipm4jy.fsf@kamboji.qca.qualcomm.com>
         <9bdf0a3a-1283-21c5-0739-e0b48dd9ddcc@codeaurora.org>
         <1482253209.30160.13.camel@redhat.com>
         <62127d4a-db9f-ab77-fb86-17d92b0ce81d@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-03-06 at 15:54 +0200, Lazar, Alexei Avshalom wrote:
> 
> The supported values are:
[...]

Regardless of the documentation, I think this is a bit fishy. Why
bother with this to start with?

We once had two patches (that we ultimately gave up on) doing something
similar but simply letting userspace decide. This was centered on
mac80211's beacon loss "link loss detection", but could easily be
generalized a little bit more:

https://p.sipsolutions.net/3a594dead519b4b2.txt
https://p.sipsolutions.net/100ce7df53692daa.txt

Perhaps with some adjustments such an approach would be workable for
you?

johannes
