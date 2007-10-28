Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:8210 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbXJ1Kp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 06:45:29 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1284457fkz
        for <linux-wireless@vger.kernel.org>; Sun, 28 Oct 2007 03:45:27 -0700 (PDT)
Message-ID: <47246844.6020109@gmail.com> (sfid-20071028_104532_032187_07702BCD)
Date: Sun, 28 Oct 2007 11:45:24 +0100
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: Change error message for failed rc module
References: <4a55afb80710271456k6c3bbfeah879b67a91a3b8d41@mail.gmail.com>	 <200710280034.41942.mb@bu3sch.de> (sfid-20071027_233701_549220_BD0E4B1B) <1193568021.3966.15.camel@johannes.berg>
In-Reply-To: <1193568021.3966.15.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>> Please compile and load rc80211_simple.
>>     
>
> rc80211_simple is so little code, can't we just compile it into mac80211
> module and make it configurable only for EMBEDDED?
>
>   
won't this conflict with drivers that want to use their own rate scaling 
modules? (like iwl3945/4965)
