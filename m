Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34405 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab0JKUvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 16:51:50 -0400
Message-ID: <4CB378CD.1080800@candelatech.com>
Date: Mon, 11 Oct 2010 13:51:25 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAB59B2.5050106@candelatech.com> <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com> <4CAB5F3D.9060201@candelatech.com> <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com> <4CAB627F.8020804@candelatech.com> <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com> <4CAB64AD.4080105@candelatech.com> <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com> <4CAB6B08.4050801@candelatech.com> <4CAE0474.4090605@candelatech.com> <1286475250.20974.22.camel@jlt3.sipsolutions.net> <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com> <4CAE13F6.2010003@candelatech.com> <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com> <4CAE1DFB.303@candelatech.com> <1286479642.20974.32.camel@jlt3.sipsolutions.net> <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com> <AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com> <AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com>
In-Reply-To: <AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/07/2010 02:59 PM, Luis R. Rodriguez wrote:
> On Thu, Oct 7, 2010 at 2:36 PM, Luis R. Rodriguez<mcgrof@gmail.com>  wrote:

>>> But other than this I got nothing. I left the box sit there for about
>>> 1 hour and came back and it was still going with no issues. Mind you,
>>> I can't ping but that seems like another issue.
>>>
>>> You can find my logs here:
>>>
>>> http://www.kernel.org/pub/linux/kernel/people/mcgrof/logs/2010/10-07-stress-sta-01/
>>
>> Doh, I did not have CONFIG_SLUB_DEBUG_ON=y so building now with that.
>
> Yay I can reproduce now. I'll be back, going to dig now.

Any luck tracking this down?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

