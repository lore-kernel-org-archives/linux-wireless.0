Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailhub-lb3.unibe.ch ([130.92.0.84]:47440 "EHLO
	mailhub-lb3.unibe.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab0G1KUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 06:20:46 -0400
Message-ID: <4C500460.5000505@iam.unibe.ch>
Date: Wed, 28 Jul 2010 12:20:16 +0200
From: Zhongliang Zhao <zhao@iam.unibe.ch>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: iw dev wlan0 link - "Not connected"
References: <4C4D5560.2040201@iam.unibe.ch> <AANLkTinfWZaiMsmPTmm5qrBRcqMAvQpv1Xq86fxo+S3Z@mail.gmail.com>
In-Reply-To: <AANLkTinfWZaiMsmPTmm5qrBRcqMAvQpv1Xq86fxo+S3Z@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/26/2010 07:23 PM, Luis R. Rodriguez wrote:
> On Mon, Jul 26, 2010 at 2:29 AM, Zhongliang Zhao<zhao@iam.unibe.ch>  wrote:
>    
>> Dear all,
>>
>> When I use "iw dev wlan0 link" to get information on wlan0 (basically to
>> check the channel used on wlan0),
>> it says: " Not connected "
>>
>> Can someone tell me how to fix this?
>>      
> Refer to:
>
> http://wireless.kernel.org/en/users/Documentation/iw#Getting_link_status
>
> And then:
>
> http://wireless.kernel.org/en/users/Documentation/iw#Establishing_a_basic_connection
>
> What you really want to use is:
>
> http://wireless.kernel.org/en/users/Documentation/wpa_supplicant
>
>    Luis
>    


Luis, thanks for the reply. But actually we're working on mesh nodes 
with the iw-tool installed, so maybe we should use the "mesh" interface 
mode. In this case, how to solve the problem?

Thanks, zhongliang
