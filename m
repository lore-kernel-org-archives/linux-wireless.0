Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-4.exch022.serverdata.net ([206.225.164.187]:20510
	"EHLO HUB022-nj-4.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932367Ab2HPNRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 09:17:14 -0400
Message-ID: <502CF2D5.6020704@posedge.com> (sfid-20120816_151831_632084_EB79E361)
Date: Thu, 16 Aug 2012 18:47:09 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCDD559@mbx022-e1-nj-10.exch022.domain.local> <20120816102211.GD17659@redhat.com>
In-Reply-To: <20120816102211.GD17659@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/16/2012 3:52 PM, Stanislaw Gruszka wrote:
> On Tue, Aug 14, 2012 at 03:55:26PM +0000, Mahesh Palivela wrote:
>> Handling of 80 MHz, 160 MHz channel bandwidths for VHT (11ac) Regulatory
>> and setting channel flags for allowed bandwidths.
>>
>> Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
>> ---
>>
>> Sending patch second time as Stanislaw Gruszka complained its malformed.
>
> And now complaining that patch is ugly. There is really on other,
> simpler way to handle that?
>
> Stanislaw
>
oh, you mean my implementation is ugly? Not a problem. Give me some 
clue, I will work on it.

Best Regards,
Mahesh
