Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37472 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab1IPRsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 13:48:53 -0400
Message-ID: <4E738BFE.7080201@qca.qualcomm.com> (sfid-20110916_194857_388038_5D933FE6)
Date: Fri, 16 Sep 2011 20:48:46 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc: "No free RX buffer" in monitor mode
References: <4E737241.2080301@qca.qualcomm.com> <CAD2nsn14EnEWyu2ifM6-5evQN4qGqe4Me7wsZ=xLPt+RBpJeWw@mail.gmail.com>
In-Reply-To: <CAD2nsn14EnEWyu2ifM6-5evQN4qGqe4Me7wsZ=xLPt+RBpJeWw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shafi,

On 09/16/2011 07:09 PM, Mohammed Shafi wrote:
> On Fri, Sep 16, 2011 at 9:28 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Hi,
>>
>> I was testing monitor mode with ath9k_htc and my laptop got slower. Then
>> I noticed this:
>>
>> [ 9246.606150] ath: No free RX buffer
>> [ 9246.606156] ath: No free RX buffer
>> [ 9246.606582] ath: No free RX buffer
>> [ 9246.606590] ath: No free RX buffer
>>
>> And I saw it quite a lot:
> 
> we saw this some time back in AP mode occasionally and it never came
> up for as in monitor mode. we need to fix this.
> i will try to fix this.

Thanks! I will run more tests with monitor mode next week and will let
you know if I see it again.

Kalle
