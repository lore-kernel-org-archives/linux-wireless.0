Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:34864 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754259Ab2K1Mir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 07:38:47 -0500
Message-ID: <50B605D2.1090803@posedge.com> (sfid-20121128_133849_705753_819103DF)
Date: Wed, 28 Nov 2012 18:08:42 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: add debugfs file for last ack signal
References: <50B5CA15.2080407@posedge.com> <1354106016.9345.4.camel@jlt4.sipsolutions.net>
In-Reply-To: <1354106016.9345.4.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/28/2012 06:03 PM, Johannes Berg wrote:

>> +		if (acked)
>> +			sta->last_ack_signal = info->status.ack_signal;
> 
> I'd prefer a blank line before the if
> 
> This patch was sent in a way that I could apply it. :-)
> 
will re-submit the patch with the blank line inserted before the if.
> johannes
> 
> 

