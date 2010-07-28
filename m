Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f66.google.com ([74.125.83.66]:51946 "EHLO
	mail-gw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab0G1SUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 14:20:48 -0400
Received: by gwb11 with SMTP id 11so326399gwb.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 11:20:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C500460.5000505@iam.unibe.ch>
References: <4C4D5560.2040201@iam.unibe.ch> <AANLkTinfWZaiMsmPTmm5qrBRcqMAvQpv1Xq86fxo+S3Z@mail.gmail.com>
	<4C500460.5000505@iam.unibe.ch>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 28 Jul 2010 10:30:21 -0700
Message-ID: <AANLkTindXiF6pjzSgz7Gp_w7qy1EeOqNgq8safE00FvG@mail.gmail.com>
Subject: Re: iw dev wlan0 link - "Not connected"
To: Zhongliang Zhao <zhao@iam.unibe.ch>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 28, 2010 at 3:20 AM, Zhongliang Zhao <zhao@iam.unibe.ch> wrote:
> On 07/26/2010 07:23 PM, Luis R. Rodriguez wrote:
>>
>> On Mon, Jul 26, 2010 at 2:29 AM, Zhongliang Zhao<zhao@iam.unibe.ch>
>>  wrote:
>>
>>>
>>> Dear all,
>>>
>>> When I use "iw dev wlan0 link" to get information on wlan0 (basically to
>>> check the channel used on wlan0),
>>> it says: " Not connected "
>>>
>>> Can someone tell me how to fix this?
>>>
>>
>> Refer to:
>>
>> http://wireless.kernel.org/en/users/Documentation/iw#Getting_link_status
>>
>> And then:
>>
>>
>> http://wireless.kernel.org/en/users/Documentation/iw#Establishing_a_basic_connection
>>
>> What you really want to use is:
>>
>> http://wireless.kernel.org/en/users/Documentation/wpa_supplicant
>>
>>   Luis
>>
>
>
> Luis, thanks for the reply. But actually we're working on mesh nodes with
> the iw-tool installed, so maybe we should use the "mesh" interface mode. In
> this case, how to solve the problem?

http://wireless.kernel.org/en/users/Documentation/iw#Creating_and_inspecting_Mesh_Point_interfaces_with_iw

Note for ath9k you currently have to issue a scan to kick the card to
beacon, its a bug, not dealt with yet.

  Luis
