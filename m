Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:40050 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZJXSK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2009 14:10:57 -0400
Message-ID: <4AE3431C.2000201@wpkg.org>
Date: Sat, 24 Oct 2009 20:10:36 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org, linux-net@vger.kernel.org,
	linux-mips@vger.kernel.org
Subject: Re: ath5k AP kernel panic when client uses SCP
References: <4AD21AB4.6010208@wpkg.org> <4AE1AC69.7010904@wpkg.org> <69e28c910910230621j2176813dpe7f77b7dff5b1b44@mail.gmail.com> <4AE1AE74.4020600@wpkg.org> <4AE2EC3E.3000503@wpkg.org> <20091024125217.GA31897@hash.localnet> <4AE31CFC.1080803@wpkg.org> <20091024160938.GC31897@hash.localnet>
In-Reply-To: <20091024160938.GC31897@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Sat, Oct 24, 2009 at 05:27:56PM +0200, Tomasz Chmielewski wrote:
>> Hmm, I get:
>>
>> 00000000 <skb_gso_segment>
>>
>> So I better leave the files here:
>>
>> http://www1.wpkg.org/skb_gso_segment/
> 
> So, do you only get this WARN() once before things go downhill?

Here is everything the system said after being powered on, including all 
page allocation failures and the final oops:

http://www1.wpkg.org/skb_gso_segment/minicom.txt

(and it looks slightly different than the last time).
-- 
Tomasz Chmielewski
http://wpkg.org
