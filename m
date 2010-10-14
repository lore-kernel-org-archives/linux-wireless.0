Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45431 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab0JNVrf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 17:47:35 -0400
Message-ID: <4CB77A70.5060900@candelatech.com>
Date: Thu, 14 Oct 2010 14:47:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAB59B2.5050106@candelatech.com>	 <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com>	 <4CAE13F6.2010003@candelatech.com>	 <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com>	 <4CAE1DFB.303@candelatech.com>	 <1286479642.20974.32.camel@jlt3.sipsolutions.net>	 <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com>	 <AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com>	 <AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com>	 <4CB378CD.1080800@candelatech.com>	 <AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com>	 <4CB3D598.7050904@candelatech.com>	 <AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com>	 <4CB4AA89.1070009@candelatech.com>	 <AANLkTinpWvMtexFTYVm5rEZY=gY7qY8WxHFtVGB0o6Se@mail.gmail.com>	 <4CB5E885.7090305@candelatech.com>	 <AANLkTi=c=w8MvXZ=vqxkRgbXasacQTYXUX8o_zXoZgxC@mail.gmail.com>	 <4CB5F0D4.4020907@candelatech.com> <1287092708.26544.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1287092708.26544.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2010 02:45 PM, Johannes Berg wrote:
> On Wed, 2010-10-13 at 10:48 -0700, Ben Greear wrote:
>
>> Here's the slub patch if you are interested in using it yourself:
>> https://patchwork.kernel.org/patch/236921/
>
> That really really screams include/linux/stacktrace.h

Heh, that looks like it would have saved me a lot of pain :P

Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

