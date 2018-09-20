Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:44260 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732257AbeITUkS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 16:40:18 -0400
Date: Thu, 20 Sep 2018 16:56:17 +0200
In-Reply-To: <15cc8087b97d4b8693fad397b27f4d10@AcuMS.aculab.com>
References: <20180919194905.16462-1-johannes@sipsolutions.net> <20180919194905.16462-2-johannes@sipsolutions.net> <15cc8087b97d4b8693fad397b27f4d10@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: RE: [PATCH v2 1/5] netlink: remove NLA_NESTED_COMPAT
To: David Laight <David.Laight@ACULAB.COM>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
From: Johannes Berg <johannes@sipsolutions.net>
Message-ID: <1811E905-CD9B-4346-AF17-CE9DBEBBE4F6@sipsolutions.net> (sfid-20180920_165653_373770_E93F3AD1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




>> @@ -172,7 +172,6 @@ enum {
>>  	NLA_FLAG,
>>  	NLA_MSECS,
>>  	NLA_NESTED,
>> -	NLA_NESTED_COMPAT,
>>  	NLA_NUL_STRING,
>>  	NLA_BINARY,
>>  	NLA_S8,
>...
>
>Is it safe to remove an item from this emun ?

I believe it is, since it's not part of uapi. At least as long as you recompile all netlink policies afterwards.

johannes 
-- 
Sent from my phone. 
