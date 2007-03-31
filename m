Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:58200 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbXCaLT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2007 07:19:58 -0400
Received: by mu-out-0910.google.com with SMTP id g7so773517muf
        for <linux-wireless@vger.kernel.org>; Sat, 31 Mar 2007 04:19:56 -0700 (PDT)
Message-ID: <460E43D6.1060501@gmail.com>
Date: Sat, 31 Mar 2007 13:19:50 +0200
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: mac80211 does not support WPA when used with wext
References: <460E2B8C.4030002@gmail.com> <1175335211.23438.45.camel@johannes.berg>
In-Reply-To: <1175335211.23438.45.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2007-03-31 at 11:36 +0200, dragoran wrote:
>   
>> Hello
>> While testing the iwlwifi driver I noticed that the mac80211 does 
>> provide a wext interface but does not support wpa with it.
>>     
>
> You must have done something wrong, it works well.
>
>   
same also happens with the rt2x00 drivers....
it seems that I am not doing something wrong but that you are using a 
ieee80211 based driver....
> johannes
>   

