Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f13.google.com ([209.85.218.13]:52663 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbYLJJNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 04:13:37 -0500
Received: by bwz6 with SMTP id 6so948011bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2008 01:13:35 -0800 (PST)
Message-ID: <8f6a4c2e0812100113l7802fd31qb295400a91e063f8@mail.gmail.com> (sfid-20081210_101340_903923_5476DA90)
Date: Wed, 10 Dec 2008 11:13:25 +0200
From: "Elmer Joandi" <elmersoft@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: wireless drivers sparse warnings
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1228829427.22164.227.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1228823435.22164.216.camel@johannes.berg>
	 <1228829427.22164.227.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, about arlan driver - I am sorry, but :
1. I lack the device and I even lack an installed 32-bit linux to compile it.
2. The card has been out of production for 10 years
3. I can not imagine anybody using it for anything sensible anymore.



To get rid of warnings the seems a need for a correct typecast to be
used in 2 places and a "static" added to a declaration.

However, as use of this driver seems to be so rare, I would suggest
marking it experimental or something like that, i.e. retire it at slow
rate.




-- 
Elmer Joandi
+3725185428
