Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:41962 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932377Ab2LFJho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 04:37:44 -0500
Message-ID: <50C06763.2080201@posedge.com> (sfid-20121206_103749_970070_CB7D4E4C)
Date: Thu, 06 Dec 2012 15:07:39 +0530
From: Chaitanya <chaitanyatk@posedge.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix the multiple warnings for budding chipsets
 without ampdu_action defined
References: <50C0545B.8060805@posedge.com> <20121206085146.GC2502@redhat.com>
In-Reply-To: <20121206085146.GC2502@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have tested the patch by applying it myself and it worked fine.
and also in My local editor (gedit) it shows tabs.

Need to check the issue and revert.

On Thursday 06 December 2012 02:21 PM, Stanislaw Gruszka wrote:
> On Thu, Dec 06, 2012 at 01:46:27PM +0530, Chaitanya wrote:
>> Changed the mail client to thunder bird to avoid whitespace issues.
>> Changed the subject and also the signing off to use offical mail.
>> Changed the setting for tabs (width=8, noexpandtab) and whitespaces.
> Don't need to mess up the change log with that.
>
>> Signed-off-by: T Krishna Chaitanya <chaitanyatk@posedge.com>
>> ---
>> net/mac80211/agg-tx.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
>> index 4152ed1..eb9df22 100644
>> --- a/net/mac80211/agg-tx.c
>> +++ b/net/mac80211/agg-tx.c
>> @@ -445,7 +445,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
>>  
>>      trace_api_start_tx_ba_session(pubsta, tid);
>>  
>> -    if (WARN_ON(!local->ops->ampdu_action))
> ^^^^^^^
> Patch is still malformed (spaces instead of one tab). Before next
> posting to mailing list, post patch to yourself and try to apply
> it. Once that success, continue with mailing list posting.
>
> Thanks
> Stanislaw  

