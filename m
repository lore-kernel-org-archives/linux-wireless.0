Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65456 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbZKYQeT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 11:34:19 -0500
Message-ID: <4B0D5C8F.3040005@trash.net>
Date: Wed, 25 Nov 2009 17:34:23 +0100
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: RFC: mac80211: add ethtool support
References: <4B0D58EA.8060304@trash.net> <1259166692.32372.13.camel@johannes.local>
In-Reply-To: <1259166692.32372.13.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2009-11-25 at 17:18 +0100, Patrick McHardy wrote:
>>     mac80211: add ethtool support
>>     
>>     Add ethtool support and add a drvname field to struct ieee80211_ops, which is
>>     used for ethtool driver information. This is useful with multiple different
>>     wireless cards to find out which device is using which driver.
>>     
> 
> I thought we _had_ ethtool support via cfg80211?!

Mhh good point :) For some reason it didn't show any information, but
that might have been a mistake on my part. I'll give it another shot :)
