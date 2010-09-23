Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36858 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab0IWVLo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 17:11:44 -0400
Message-ID: <4C9BC28E.7010105@candelatech.com>
Date: Thu, 23 Sep 2010 14:11:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Detect if phy is a/b/g/n?
References: <4C9BA6ED.8080304@candelatech.com> <AANLkTinY7y7Gf8K518293mdzXh5=42gQ64eUJjJFSaBw@mail.gmail.com>
In-Reply-To: <AANLkTinY7y7Gf8K518293mdzXh5=42gQ64eUJjJFSaBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/2010 01:35 PM, Luis R. Rodriguez wrote:
> On Thu, Sep 23, 2010 at 12:13 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> Is there a way to determine what a/b/g/n modes a particular phy
>> supports?  I tried 'iw phy', but I didn't see anything
>> obvious.
>
> 'iw list' Rates?

Both a/b/g (ath5k) and /n (ath9k) show top speed of 54Mbps
on my systems.

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

