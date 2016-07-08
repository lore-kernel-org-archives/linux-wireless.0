Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58563 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbcGHPrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 11:47:23 -0400
Subject: Re: ath10k + iw set bitrates is causing FW crash
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
References: <CABPxzYLwye1t1Ycjr3nO5C18vc7OqS9dbbQ1yJ7B-YN+Bkx_PA@mail.gmail.com>
 <CABPxzYL5DHU7ZE1X1AibygBUz0TJEnNLLTp5_hDivmBBkjnVtg@mail.gmail.com>
 <1467972560885.99812@qti.qualcomm.com>
 <CABPxzY+8Y-FHUFALGueN1hQwgjJHNpeyy_BRkrM4osguxJZS0Q@mail.gmail.com>
 <1467982766213.21223@qti.qualcomm.com>
 <CABPxzYLO8rzvOJ_1iqng89kYFS-xqC3qstbgETVRJHDpO4rikQ@mail.gmail.com>
 <CABPxzYJPi4CqO+KUFA7=r=zpq_c2vFtrgBQ+nF_nThO-cYrteg@mail.gmail.com>
 <CABPxzYKOqBmrjRwAyZV9daV8adEhUV71XEAsfrLhtTnKwWzuaw@mail.gmail.com>
 <577FC9D0.2010809@candelatech.com>
 <CABPxzYLdS-QicOj9AdcubT8uxgw0cqXpzerpuwGcwkSQ7PCiOA@mail.gmail.com>
Cc: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <577FCB04.4030905@candelatech.com> (sfid-20160708_174730_461131_9511C085)
Date: Fri, 8 Jul 2016 08:47:16 -0700
MIME-Version: 1.0
In-Reply-To: <CABPxzYLdS-QicOj9AdcubT8uxgw0cqXpzerpuwGcwkSQ7PCiOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/2016 08:44 AM, Krishna Chaitanya wrote:
> On Fri, Jul 8, 2016 at 9:12 PM, Ben Greear <greearb@candelatech.com> wrote:
>> On 07/08/2016 08:39 AM, Krishna Chaitanya wrote:
>>
>>> Also can you please tell me how to make ath10k use minstrel rc, its needed
>>> for comparative purposes? Is disable HW_RATE_CONTROL enough or does
>>> it need more changes?
>>
>>
>> It cannot be done.  You have to use whatever rate-ctrl is baked into the
>> firmware.
> Ok, its a good feature to have.
>

It is unlikely to happen anytime soon.  It requires significant firmware
modification (and driver too), and probably you would have to add MU-MIMO
support to minstrel if you wanted to support latest ath10k NICs.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

